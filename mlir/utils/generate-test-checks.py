#!/usr/bin/env python3
"""A script to generate FileCheck statements for mlir unit tests.

This script is a utility to add FileCheck patterns to an mlir file.

NOTE: The input .mlir is expected to be the output from the parser, not a
stripped down variant.

Example usage:
$ generate-test-checks.py foo.mlir
$ mlir-opt foo.mlir -transformation | generate-test-checks.py

The script will heuristically insert CHECK/CHECK-LABEL commands for each line
within the file. By default this script will also try to insert string
substitution blocks for all SSA value names. The script is designed to make
adding checks to a test case fast, it is *not* designed to be authoritative
about what constitutes a good test!
"""

# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import os  # Used to advertise this file's name ("autogenerated_note").
import re
import sys

ADVERT = '// NOTE: Assertions have been autogenerated by '

# Regex command to match an SSA identifier.
SSA_RE_STR = '[0-9]+|[a-zA-Z$._-][a-zA-Z0-9$._-]*'
SSA_RE = re.compile(SSA_RE_STR)


# Class used to generate and manage string substitution blocks for SSA value
# names.
class SSAVariableNamer:

  def __init__(self):
    self.scopes = []
    self.name_counter = 0

  # Generate a substitution name for the given ssa value name.
  def generate_name(self, ssa_name):
    variable = 'VAL_' + str(self.name_counter)
    self.name_counter += 1
    self.scopes[-1][ssa_name] = variable
    return variable

  # Push a new variable name scope.
  def push_name_scope(self):
    self.scopes.append({})

  # Pop the last variable name scope.
  def pop_name_scope(self):
    self.scopes.pop()

  def num_scopes(self):
    return len(self.scopes)

  def clear_counter(self):
    self.name_counter = 0


# Process a line of input that has been split at each SSA identifier '%'.
def process_line(line_chunks, variable_namer):
  output_line = ''

  # Process the rest that contained an SSA value name.
  for chunk in line_chunks:
    m = SSA_RE.match(chunk)
    ssa_name = m.group(0)

    # Check if an existing variable exists for this name.
    variable = None
    for scope in variable_namer.scopes:
      variable = scope.get(ssa_name)
      if variable is not None:
        break

    # If one exists, then output the existing name.
    if variable is not None:
      output_line += '%[[' + variable + ']]'
    else:
      # Otherwise, generate a new variable.
      variable = variable_namer.generate_name(ssa_name)
      output_line += '%[[' + variable + ':.*]]'

    # Append the non named group.
    output_line += chunk[len(ssa_name):]

  return output_line.rstrip() + '\n'


def process_source_lines(source_lines, note, args):
  source_split_re = re.compile(args.source_delim_regex)

  source_segments = [[]]
  for line in source_lines:
    if line == note:
      continue
    if line.find(args.check_prefix) != -1:
      continue
    if source_split_re.search(line):
      source_segments.append([])

    source_segments[-1].append(line + '\n')
  return source_segments


# Pre-process a line of input to remove any character sequences that will be
# problematic with FileCheck.
def preprocess_line(line):
  # Replace any double brackets, '[[' with escaped replacements. '[['
  # corresponds to variable names in FileCheck.
  output_line = line.replace('[[', '{{\\[\\[}}')

  # Replace any single brackets that are followed by an SSA identifier, the
  # identifier will be replace by a variable; Creating the same situation as
  # above.
  output_line = output_line.replace('[%', '{{\\[}}%')

  return output_line


def main():
  parser = argparse.ArgumentParser(
      description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
  parser.add_argument(
      '--check-prefix', default='CHECK', help='Prefix to use from check file.')
  parser.add_argument(
      '-o',
      '--output',
      nargs='?',
      type=argparse.FileType('w'),
      default=None)
  parser.add_argument(
      'input',
      nargs='?',
      type=argparse.FileType('r'),
      default=sys.stdin)
  parser.add_argument(
      '--source', type=str,
      help='Print each CHECK chunk before each delimeter line in the source'
           'file, respectively. The delimeter lines are identified by '
           '--source_delim_regex.')
  parser.add_argument('--source_delim_regex', type=str, default='func @')
  parser.add_argument(
      '--starts_from_scope', type=int, default=1,
      help='Omit the top specified level of content. For example, by default '
           'it omits "module {"')
  parser.add_argument('-i', '--inplace', action='store_true', default=False)

  args = parser.parse_args()

  # Open the given input file.
  input_lines = [l.rstrip() for l in args.input]
  args.input.close()

  # Generate a note used for the generated check file.
  script_name = os.path.basename(__file__)
  autogenerated_note = (ADVERT + 'utils/' + script_name)

  source_segments = None
  if args.source:
    source_segments = process_source_lines(
        [l.rstrip() for l in open(args.source, 'r')],
        autogenerated_note,
        args
    )

  if args.inplace:
    assert args.output is None
    output = open(args.source, 'w')
  elif args.output is None:
    output = sys.stdout
  else:
    output = args.output

  output_segments = [[]]
  # A map containing data used for naming SSA value names.
  variable_namer = SSAVariableNamer()
  for input_line in input_lines:
    if not input_line:
      continue
    lstripped_input_line = input_line.lstrip()

    # Lines with blocks begin with a ^. These lines have a trailing comment
    # that needs to be stripped.
    is_block = lstripped_input_line[0] == '^'
    if is_block:
      input_line = input_line.rsplit('//', 1)[0].rstrip()

    cur_level = variable_namer.num_scopes()

    # If the line starts with a '}', pop the last name scope.
    if lstripped_input_line[0] == '}':
      variable_namer.pop_name_scope()
      cur_level = variable_namer.num_scopes()

    # If the line ends with a '{', push a new name scope.
    if input_line[-1] == '{':
      variable_namer.push_name_scope()
      if cur_level == args.starts_from_scope:
        output_segments.append([])

    # Omit lines at the near top level e.g. "module {".
    if cur_level < args.starts_from_scope:
      continue

    if len(output_segments[-1]) == 0:
      variable_namer.clear_counter()

    # Preprocess the input to remove any sequences that may be problematic with
    # FileCheck.
    input_line = preprocess_line(input_line)

    # Split the line at the each SSA value name.
    ssa_split = input_line.split('%')

    # If this is a top-level operation use 'CHECK-LABEL', otherwise 'CHECK:'.
    if len(output_segments[-1]) != 0 or not ssa_split[0]:
      output_line = '// ' + args.check_prefix + ': '
      # Pad to align with the 'LABEL' statements.
      output_line += (' ' * len('-LABEL'))

      # Output the first line chunk that does not contain an SSA name.
      output_line += ssa_split[0]

      # Process the rest of the input line.
      output_line += process_line(ssa_split[1:], variable_namer)

    else:
      # Output the first line chunk that does not contain an SSA name for the
      # label.
      output_line = '// ' + args.check_prefix + '-LABEL: ' + ssa_split[0] + '\n'

      # Process the rest of the input line on separate check lines.
      for argument in ssa_split[1:]:
        output_line += '// ' + args.check_prefix + '-SAME:  '

        # Pad to align with the original position in the line.
        output_line += ' ' * len(ssa_split[0])

        # Process the rest of the line.
        output_line += process_line([argument], variable_namer)

    # Append the output line.
    output_segments[-1].append(output_line)

  output.write(autogenerated_note + '\n')

  # Write the output.
  if source_segments:
    assert len(output_segments) == len(source_segments)
    for check_segment, source_segment in zip(output_segments, source_segments):
      for line in check_segment:
        output.write(line)
      for line in source_segment:
        output.write(line)
  else:
    for segment in output_segments:
      output.write('\n')
      for output_line in segment:
        output.write(output_line)
    output.write('\n')
  output.close()


if __name__ == '__main__':
  main()
