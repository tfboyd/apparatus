"""Run command locally."""
from __future__ import print_function

import subprocess


def run_local_command(cmd, shell=True):
  """Structures for a variety of different test results.

  Args:
    cmd: Command to execute
  Returns:
    Tuple of the command return value and the standard out in as a string.
  """
  print(cmd)
  p = subprocess.Popen(
      cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=shell)
  stdout = ''
  while True:
    retcode = p.poll()
    tmp_stdout = p.stdout.readline()
    print(tmp_stdout)
    stdout += tmp_stdout
    if retcode is not None:
      return retcode, stdout


def run_list_of_commands(cmds, throw_error=True, shell=True):
  """Runs list of command and throw error if any fail."""
  for cmd in cmds:
    retcode, log = run_local_command(cmd, shell=shell)
    if retcode and throw_error:
      raise Exception('"{}" failed with code:{} and log:\n{}'.
                      format(cmd, retcode, log))
