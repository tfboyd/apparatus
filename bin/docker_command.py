#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys
import yaml


def main():
  cmd_file = sys.argv[1]

  os.system('docker build . -t foo')
  os.system('nvidia-docker run -i -t foo:latest /root/docker-bin/run_command /root/{}'.format(cmd_file))


if __name__ == '__main__':
  main()

