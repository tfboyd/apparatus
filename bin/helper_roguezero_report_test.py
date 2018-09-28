# Copyright 2017 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
from __future__ import print_function

import unittest
import sys

from mock import Mock
from mock import patch

sys.modules['cpu'] = Mock()
sys.modules['nvidia'] = Mock()
sys.modules['result_info'] = Mock()
sys.modules['result_upload'] = Mock()
sys.modules['tf_version'] = Mock()

import helper_roguezero_report


class TestHelperRogueZeroReport(unittest.TestCase):

  @patch('result_info.build_test_info')
  @patch('result_info.build_system_info')
  @patch('result_info.build_test_result')
  @patch('tf_version.get_tf_full_version')
  def test_build_report_result(self, get_tf_full_version, build_result,
                               build_system_info, build_test_info):
    """Tests creating row to be inserted."""
    mock_gpu_info, mock_cpu_info = self._patch_logs_git_gpu()

    expected_version = ['1.5RC0-dev20171001', 'v1.3.0-rc1-2884-g2d5b76169']
    get_tf_full_version.return_value = expected_version
    build_result.return_value = ['foo', 'bar']

    test_id = 'crazy.foo.bar.test'
    total_time = '29001'
    helper_roguezero_report.build_entry(test_id, total_time)

    build_result_args = build_result.call_args
    build_system_info_args = build_system_info.call_args
    build_test_info_args = build_test_info.call_args

    mock_gpu_info.assert_called()
    mock_cpu_info.assert_called()
    get_tf_full_version.assert_called()

    # Verifies core columns.
    self.assertEqual(build_result_args[0][0], test_id)
    self.assertEqual(build_result_args[0][1], total_time)
    self.assertEqual(build_system_info_args[1]['accel_type'], 'GTX 970')
    self.assertEqual(build_system_info_args[1]['cpu_cores'], 64)
    self.assertEqual(build_test_info_args[1]['framework_version'],
                     '1.5RC0-dev20171001')

  @patch('result_info.build_test_info')
  @patch('result_info.build_system_info')
  @patch('result_info.build_test_result')
  @patch('tf_version.get_tf_full_version')
  def test_build_report_result_accel_type(self, get_tf_full_version,
                                          build_result, build_system_info,
                                          build_test_info):
    """Tests creating row to be inserted."""
    mock_gpu_info, mock_cpu_info = self._patch_logs_git_gpu()

    expected_version = ['1.5RC0-dev20171001', 'v1.3.0-rc1-2884-g2d5b76169']
    get_tf_full_version.return_value = expected_version
    build_result.return_value = ['foo', 'bar']

    test_id = 'crazy.foo.bar.test'
    total_time = '29001'
    helper_roguezero_report.build_entry(test_id, total_time, accel_type='TPUx4')

    build_result_args = build_result.call_args
    build_system_info_args = build_system_info.call_args
    build_test_info_args = build_test_info.call_args

    mock_gpu_info.assert_not_called()
    mock_cpu_info.assert_called()
    get_tf_full_version.assert_called()

    # Verifies core columns.
    self.assertEqual(build_result_args[0][0], test_id)
    self.assertEqual(build_result_args[0][1], total_time)
    self.assertEqual(build_system_info_args[1]['accel_type'], 'TPUx4')
    self.assertEqual(build_system_info_args[1]['cpu_cores'], 64)
    self.assertEqual(build_test_info_args[1]['framework_version'],
                     '1.5RC0-dev20171001')

  def _patch_logs_git_gpu(self, gpu_info=None):
    gpu_info = gpu_info or [387.11, 'GTX 970']
    patch_gpu_info = patch('nvidia.get_gpu_info')
    patch_cpu_info = patch('cpu.get_cpu_info')

    mock_cpu_info = patch_cpu_info.start()
    mock_cpu_info.return_value = ['XEON 2600E 2.0Ghz', 2, 64, 'Lots of foo']
    mock_gpu_info = patch_gpu_info.start()
    mock_gpu_info.return_value = gpu_info

    self.addCleanup(patch_cpu_info.stop)
    self.addCleanup(patch_gpu_info.stop)

    return mock_gpu_info, mock_cpu_info
