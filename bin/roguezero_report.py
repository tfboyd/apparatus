#!/usr/bin/env python

import os
import importlib.util



def report_result(test_id, mlperf_score, platform_type='p3.8xlarge', extras={}, dev=True):
    os.system('rm -rf benchmark_harness')
    os.system('git clone https://github.com/tfboyd/benchmark_harness.git')
    upload_spec = importlib.util.spec_from_file_location("result_upload", "./benchmark_harness/oss_bench/upload/result_upload.py")
    result_upload = importlib.util.module_from_spec(upload_spec)
    upload_spec.loader.exec_module(result_upload)
    info_spec = importlib.util.spec_from_file_location("result_info", "./benchmark_harness/oss_bench/upload/result_info.py")
    result_info = importlib.util.module_from_spec(info_spec)
    info_spec.loader.exec_module(result_info)
    #print(result_upload)
    #print(result_info)

    #extras = {}
    #extras['victor'] = 'victor test'
    test_result, results = result_info.build_test_result(test_id, mlperf_score, result_units='s')
    system_info = result_info.build_system_info(
      platform='gcp', platform_type=platform_type)
    test_info = result_info.build_test_info(batch_size=1)

    result_upload.upload_result(
      test_result,
      results,
      'google.com:tensorflow-performance',
      test_info=test_info,
      system_info=system_info,
      extras=extras)

    os.system('rm -rf benchmark_harness')

report_result()
