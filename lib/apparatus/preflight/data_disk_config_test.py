"""Tests data disk config module."""
from __future__ import print_function

import unittest

import apparatus.preflight.data_disk_config as data_disk_config
from mock import patch


class TestNvidiaTools(unittest.TestCase):

  @patch('apparatus.preflight.data_disk_config._get_nvme_device_list')
  def test_get_device_list(self, mock_device_list):
    """Tests ok_to_run not finding existing processes."""
    device_test = 'apparatus/preflight/unittest_files/nvme_device_log.txt'
    with open(device_test) as f:
      mock_device_list.return_value = f.read()
    devices = data_disk_config.get_nvme_device_list()
    print(devices)
    self.assertTrue(devices)
