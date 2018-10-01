#!/usr/bin/env python
"""Reports results of tests."""

from __future__ import print_function

import os
import sys


def build_upload(test_id, result, quality, quality_type, project=None,
                 extras=None):
  """Build and upload the results."""
  # Modules are loaded by this function.
  # pylint: disable=C6204
  import helper_roguezero_report as rogue_report

  main_result, results, test_info, system_info = rogue_report.build_entry(
      test_id,
      result)

  if quality:
    rogue_report.add_quality_result(results, quality, quality_type=quality_type)

  rogue_report.report_result(
      main_result,
      results,
      test_info,
      system_info,
      project=project,
      dev=False,
      extras=extras)


def create_report(output_dir, project):
  """Create report for the test."""
  result = None
  quality = None
  quality_type = None
  epoch_count = 0
  epoch_lines = []
  with open(os.path.join(output_dir, 'output.txt')) as f:
    for l in f:
      if l.startswith('RESULT'):
        stuff = l.split(',')
        result = stuff[3]
      if 'Iteration' in l:
        epoch_count += 1
        epoch_lines.append(l)
      if 'Beginning data preprocessing' in l:
        epoch_lines.append(l)
  if result is None:
    # TODO(victor) do something better
    result = 0
    print('ERROR: No result was found!!')
  test_id = os.path.basename(output_dir)

  extras = {}
  extras['epoch_count'] = epoch_count
  extras['epoch_lines'] = epoch_lines

  build_upload(test_id, result, quality, quality_type, project=project,
               extras=extras)


def main():
  # Pull down and Load  RogueZero modules.
  os.system('rm -rf benchmark_harness')
  os.system('git clone https://github.com/tfboyd/benchmark_harness.git')
  # Module to upload results
  sys.path.append('./benchmark_harness/oss_bench/upload/')
  # Module to pull system information
  sys.path.append('./benchmark_harness/oss_bench/tools/')

  # Create and upload report.
  project = 'google.com:tensorflow-performance'
  if len(sys.argv) >= 3:
    project = sys.argv[2]

  create_report(sys.argv[1], project)
  os.system('rm -rf benchmark_harness')

if __name__ == '__main__':
  main()
