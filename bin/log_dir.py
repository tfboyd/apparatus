#!/usr/bin/env python

import json
import os
import pprint
import socket
import subprocess
import sys
import tempfile
import time
import yaml
import argparse


def log_dir(dir_path, run_group):
  cmd = 'gsutil cp -r {} gs://mlperf-runs/{}/'.format(dir_path, run_group)
  print(cmd)
  return os.system(cmd)


def main():
  parser = argparse.ArgumentParser(description='Log a run.')
  parser.add_argument('path', metavar='PATH', type=str, help='path to dir to log')
  parser.add_argument('--run_group', help='the run group to log under', default='unknown')
  args = parser.parse_args()
  
  if log_dir(args.path, args.run_group) != 0:
    sys.exit(1)


if __name__ == '__main__':
  main()

