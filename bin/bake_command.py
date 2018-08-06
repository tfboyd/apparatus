#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import sys
import yaml


def bake_command(name, config):
  print('pushd ' + config['repo_cwd'])
  argv = config['argv']
  new_argv = []
  for a in argv:
    if a.startswith('P%'):
      new_argv.append(sugar[a[2:]])
    else:
      new_argv.append(a)
  print(' '.join(new_argv))


def main():
  cmd_file = sys.argv[1]
  with open(cmd_file) as f:
    cmd_def = yaml.load(f)

  print('#!/bin/bash')
  print('git clone {} {}'.format(cmd_def['github_repo'], cmd_def['local_repo_name']))
  print('cd ' + cmd_def['local_repo_name'])

  for cmd in cmd_def['commands']:
    name, config = list(cmd.items())[0]
    bake_command(name, config)


if __name__ == '__main__':
  main()
