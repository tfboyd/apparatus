#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys
import yaml
import subprocess
import time

DOCKER_VERSION = 1

MOUNT_NAME_TO_PATH = {
  'imagenet': '/imn'
}


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


def run_docker_cmd(cmd_str, output_dir):
  with open(os.path.join(output_dir, 'command_line.txt'), 'w') as f:
    f.write(cmd_str)

  #stdout_file = open(os.path.join(output_dir, 'run_stdout.txt'), 'w')
  #stderr_file = open(os.path.join(output_dir, 'run_stderr.txt'), 'w')
  # proc = subprocess.Popen(cmd_str, stdout=stdout_file, stderr=stderr_file, shell=True)
  proc = subprocess.Popen(cmd_str, shell=True)
  while proc.poll() is None:
    # process is still running
    time.sleep(5)
  return proc.returncode == 0


def main():
  print('DEBUG === pip3 freeze')
  sys.stdout.flush()
  os.system('pip3 freeze')
  print('DEBUG === pip freeze')
  sys.stdout.flush()
  os.system('pip freeze')
  print('DEBUG === pip3 freeze')
  sys.stdout.flush()
  os.system('pip3 freeze')
  print('DEBUG === python3 --version')
  sys.stdout.flush()
  os.system('python3 --version')
  print('DEBUG === python --version')
  sys.stdout.flush()
  os.system('python --version')
  
  cmd_file = sys.argv[1]
  output_dir = sys.argv[2]
  os.system("mkdir {}".format(output_dir))

  with open(cmd_file) as f:
    cmd_def = yaml.load(f)

  mounts = [output_dir + ':/output']
  if 'docker_mounts' in cmd_def:
    for name, dock_mnt in cmd_def['docker_mounts'].items():
      host_mnt = MOUNT_NAME_TO_PATH[name]
      mounts.append(host_mnt + ':' + dock_mnt)
    
  copy_and_set_vars(cmd_def, version=DOCKER_VERSION)

  if os.system('sudo nvidia-docker build . -t foo') != 0:
    sys.exit(1)
  # use docker_mounts to mount...
  # 
  mnt_str = ' '.join(map(lambda s: '-v ' + s, mounts))
  docker_cmd = 'sudo nvidia-docker run {} -t foo:latest /root/docker-bin/run_command /root/{} 2>&1 | tee {}/output.txt'.format(mnt_str, cmd_file, output_dir)
  print('Docker Command:')
  print(docker_cmd)
  if not run_docker_cmd(docker_cmd, output_dir):
    sys.exit(1)


if __name__ == '__main__':
  main()

