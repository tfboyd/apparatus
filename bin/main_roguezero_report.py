#!/usr/bin/env python
"""Reports results of tests."""

from __future__ import print_function

import datetime
import os
import sys
import uuid


def get_env_var(varname, default='unknown'):
    if varname in os.environ:
        return os.environ[varname]
    return default


def build_upload(test_id, result, quality, quality_type, project=None,
                 extras=None):
  """Build and upload the results."""
  # Modules are loaded by this function.
  # pylint: disable=C6204
  import helper_roguezero_report as rogue_report

  group_id = get_env_var('ROGUE_ZERO_GROUP_RUN_ID')
  if 'nightly' in group_id:
      group_id = group_id + '_' + str(datetime.datetime.today().day)

  main_result, results, test_info, system_info = rogue_report.build_entry(
      test_id,
      group_run_id=group_id,
      platform_type=get_env_var('ROGUE_ZERO_PLATFORM_TYPE'),
      total_time=result)

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


def create_report(output_dir, project, compliance_level, delta_t, quality):
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
  test_id = get_env_var('ROGUE_ZERO_TEST_ID')

  extras = {}

  extras['compliance_level'] = compliance_level
  if compliance_level != '0':
      result = delta_t

  print('Reporting: ', extras)
  print('Reporting result: ', result)

  build_upload(test_id, result, quality, quality_type, project=project,
               extras=extras)


def get_compliance(filename):
    import mlp_compliance

    print('Running Compliance Check')
    print('#' * 80)
    status, dt, qual, target = mlp_compliance.l2_check_file(filename)
    print('#' * 80)

    if status:
        level = '2'
    else:
      status, dt, qual, target = mlp_compliance.l1_check_file(filename)
      print('#' * 80)
      if status:
        level = '1'
      else:
        level = '0'

    success = status and qual and target and qual >= target
    return level, dt, qual, success


def save_results(code_dir, output_file):
    test_id = get_env_var('ROGUE_ZERO_TEST_ID')
    target_code_dir = get_env_var('ROGUE_CODE_DIR', None)

    uid = uuid.uuid4()
    print('This identifier is: ', uid)


    if code_dir is None:
        print('Not saving the code from this run!')
    else:
        # save the code
        print('Saving code to: {}'.format(target_code_dir))
        os.system('sudo tar czf /tmp/{}.tar.gz {}'.format(uid, code_dir))
        os.system('sudo chmod 777 /tmp/{}.tar.gz'.format(uid))
        os.system('gsutil cp -r /tmp/{}.tar.gz {}/'.format(uid, target_code_dir))
        print('Saved code.')


    target_log_dir = get_env_var('ROGUE_LOG_DIR', None)
    if  dir is None:
        print('Not saving the log from this run!')
    else:
        # save the logfile
        print('Saving log to: {}'.format(target_code_dir))
        os.system('gsutil cp -r {} {}/{}.log'.format(output_file, target_log_dir, uid))
        print('Saved code.')



def main():
  # Pull down and Load  RogueZero modules.
  os.system('rm -rf benchmark_harness')
  os.system('git clone https://github.com/tfboyd/benchmark_harness.git')
  # Module to upload results
  sys.path.append('./benchmark_harness/oss_bench/upload/')
  # Module to pull system information
  sys.path.append('./benchmark_harness/oss_bench/tools/')

  # Compliance Checker
  os.system('rm -rf ./mlp_compliance')
  os.system('git clone https://github.com/bitfort/mlp_compliance.git')
  sys.path.append('./mlp_compliance/')

  # Create and upload report.
  project = 'google.com:tensorflow-performance'
  if len(sys.argv) >= 3:
    project = sys.argv[2]

  compliance_level, dt, qual, success = get_compliance(sys.argv[1] + '/output.txt')
  save_results(sys.argv[1], sys.argv[1] + '/output.txt')

  create_report(sys.argv[1], project, compliance_level, dt, qual)

  os.system('rm -rf benchmark_harness')
  sys.exit(0 if success else 1)


if __name__ == '__main__':
  main()
