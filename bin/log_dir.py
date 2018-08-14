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

from tensorflow import gfile

''' jsons structure for a run:
{
  command_line: "ps -ef",
  status_dir: 'gs://mlperf-control/status'
  output_dir: 'gs://mlperf-control/job-out/'
}
'''

def get_hostname():
  return socket.gethostname()


def status_filename(status_dir):
  return '{}/{}.txt'.format(status_dir, get_hostname())


def read_json(json_path):
  with gfile.Open(json_path, 'r') as f:
    return json.loads(f.read())


def run_cmd(run_def):
  #stdout_file = tempfile.NamedTemporaryFile()
  #stderr_file = tempfile.NamedTemporaryFile()
  proc = subprocess.Popen([run_def['executable_path']], cwd=run_def['executable_cwd'],
                          #stdout=stdout_file, stderr=stderr_file,
                          shell=True)
  while proc.poll() is None:
    # process is still running
    time.sleep(5)
    print('Waiting...')


def run_loop():
  j = read_json(sys.argv[1])
  write_status(j)
  stdout_file = tempfile.NamedTemporaryFile()
  stderr_file = tempfile.NamedTemporaryFile()
  proc = subprocess.Popen(j['command_line'], stdout=stdout_file, stderr=stderr_file, shell=True)
  while proc.poll() is None:
    # process is still running
    time.sleep(5)
    write_status(j)
  finalize(proc.returncode, j, stdout_file, stderr_file)


def write_status(j):
  with gfile.Open(status_filename(j['status_dir']), 'w') as f:
    f.write(str(int(time.time())) + '\n')
    f.write(pprint.pformat(j))


def finalize(retcode, j, stdout_file, stderr_file):
  stdout_file.flush()
  stderr_file.flush()

  out_dir = j['output_dir'].strip('/')
  os.system('gsutil cp {} {}/stdout.txt'.format(stdout_file.name, out_dir))
  os.system('gsutil cp {} {}/stderr.txt'.format(stderr_file.name, out_dir))

  with gfile.Open('{}/return_code.txt'.format(out_dir), 'w') as f:
    f.write(str(retcode))

  return


def main():
  run_yaml_file = sys.argv[1]
  with open(run_yaml_file) as f:
    run_def = yaml.load(f)
  run_cmd(run_def)


if __name__ == '__main__':
  main()

