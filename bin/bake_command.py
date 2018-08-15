#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import sys
import yaml


def bake_command(name, config):
  repo_cwd = config['repo_cwd']
  script_name = None
  if 'script' in config:
      script_name = config['script']
      # copy script to the correct directory
      print('cp ../scripts/{} {}/'.format(script_name, repo_cwd))

  print('pushd ' + repo_cwd)
  argv = config['argv']
  new_argv = []
  if script_name is not None:
      new_argv = ['bash', script_name]
  for a in argv:
    if type(a) is str and a.startswith('P%'):
      new_argv.append(str(sugar[a[2:]]))
    else:
      new_argv.append(str(a))
  print(' '.join(new_argv))
  print('popd')


def main():
  cmd_file = sys.argv[1]
  with open(cmd_file) as f:
    cmd_def = yaml.load(f)

  print('#!/bin/bash')
  print('set -e')
  print('cd ' + cmd_def['local_repo_name'])
  for cmd in cmd_def['commands']:
    name, config = list(cmd.items())[0]
    bake_command(name, config)


if __name__ == '__main__':
  main()
