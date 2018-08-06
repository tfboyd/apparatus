#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import sys
import os
import yaml


def main():
  cmd_file = sys.argv[1]
  with open(cmd_file) as f:
    cmd_def = yaml.load(f)

  status = os.system(cmd_def['docker_setup_script'])
  print('Run Docker Setup Status: ', status)
  if status != 0:
    sys.exit(1)


if __name__ == '__main__':
  main()
