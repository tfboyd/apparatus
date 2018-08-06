#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys
import yaml
import time

DOCKER_VERSION = 1


def copy_and_set_vars(cmd_def, version):
  vars = {
	'%DOCKER_FROM': cmd_def['docker_vars']['DOCKER_FROM'],
	'%VERSION_INFO': str(version),
	'%%GIT_CHECKOUT': 'RUN git clone {} {}'.format(cmd_def['github_repo'], cmd_def['local_repo_name']),
	}
  if 'DOCKER_SCRIPT' in cmd_def['docker_vars']:
    vars['%%DOCKER_SCRIPT'] = 'RUN /root/{}'.format(cmd_def['docker_vars']['DOCKER_SCRIPT'])
  

  with open('Dockerfile.tmpl') as f:
    with open('Dockerfile', 'w') as o:
      for l in f:
        for k, v in vars.items():
          l = l.replace(k, v)
        o.write(l)


def main():
  cmd_file = sys.argv[1]

  with open(cmd_file) as f:
    cmd_def = yaml.load(f)

  copy_and_set_vars(cmd_def, version=DOCKER_VERSION)

  if os.system('sudo nvidia-docker build . -t foo') != 0:
    sys.exit(1)
  if os.system('sudo nvidia-docker run -i -t foo:latest /root/docker-bin/run_command /root/{}'.format(cmd_file)) != 0:
    sys.exit(1)


if __name__ == '__main__':
  main()

