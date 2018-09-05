#!/usr/bin/env python

import sys
import os
import importlib.util



def report_result(test_id, mlperf_score, platform_type='gcp', extras={}, dev=True):
    os.system('rm -rf benchmark_harness')
    os.system('git clone https://github.com/tfboyd/benchmark_harness.git')
    sys.path.append('./benchmark_harness/oss_bench/upload/')
    #upload_spec = importlib.util.spec_from_file_location("result_upload", "./benchmark_harness/oss_bench/upload/result_upload.py")
    #result_upload = importlib.util.module_from_spec(upload_spec)
    #upload_spec.loader.exec_module(result_upload)
    #info_spec = importlib.util.spec_from_file_location("result_info", "./benchmark_harness/oss_bench/upload/result_info.py")
    #result_info = importlib.util.module_from_spec(info_spec)
    #info_spec.loader.exec_module(result_info)

    import result_upload
    import result_info
    #print(result_upload)
    #print(result_info)

    #extras = {}
    #extras['victor'] = 'victor test'
    test_result, results = result_info.build_test_result(test_id, mlperf_score, result_units='s')
    system_info = result_info.build_system_info(
      platform='gcp', platform_type=platform_type)
    test_info = result_info.build_test_info(batch_size=1)

    dataset = 'benchmark_results_dev'
    if not dev:
        dataset = 'benchmark_results'

    result_upload.upload_result(
      test_result,
      results,
      'google.com:tensorflow-performance',
      test_info=test_info,
      system_info=system_info,
      extras=extras,
      dataset=dataset)
    print('RogueZero Reported.')

    os.system('rm -rf benchmark_harness')

def main():
    output_dir = sys.argv[1]

    result = None
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
        # TODO do something better
        result = 0
    report_result(os.path.basename(output_dir), result, dev=False, extras={'epoch_count': epoch_count, 'epoch_lines': '\n'.join(epoch_lines)})
        

if __name__ == '__main__':
    main()

