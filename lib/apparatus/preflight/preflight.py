"""Sets up local host before benchmark is executed in Docker."""
from __future__ import print_function

import argparse
import os
import sys

import apparatus.common.git as git
import apparatus.common.local_command as local_command
import apparatus.preflight.data_disk_config as data_disk_config

import yaml


class Preflight(object):
  """Handles setup of environment before execute of benchmark."""

  def __init__(self,
               benchmark_file,
               benchmark_dir,
               disk_dir='/data',
               gce_nvme_raid=None,
               ram_disk_size=0,
               download=True):
    """Initalize Preflight."""

    # Path to the top level workspace with all of apparatus.
    self.workspace = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                  '../../..'))
    self.benchmark_dir = os.path.join(self.workspace, benchmark_dir)
    self.benchmark_file = os.path.join(self.workspace, benchmark_file)
    self.config = self._load_config(self.benchmark_file)

    self.disk_dir = disk_dir
    self.gce_nvme_raid = gce_nvme_raid
    self.ram_disk_size = ram_disk_size
    self.download = download

    if 'model' in self.config:
      self.model = self.config['model']
    else:
      raise Exception('"model" attribute must exist in config: {}'.
                      format(self.benchmark_file))

  def execute_preflight(self):
    """Execute the preflight to setup for tests."""
    # Add items to Python Path
    apparatus_bin = os.path.join(self.workspace, 'bin')
    lib_paths = [apparatus_bin]
    for lib_path in lib_paths:
      print('Add to PYTHONPATH:{}'.format(lib_path))
      sys.path.append(lib_path)

    # Calls to setup data disk
    if self.gce_nvme_raid:
      devices = self.gce_nvme_raid.split(',')
      data_disk_config.create_gce_nvme_raid(self.disk_dir, devices)
    elif self.ram_disk_size:
      data_disk_config.create_ram_disk(self.disk_dir, self.ram_disk_size)

    # Call model function to setup model
    if self.model == 'resnet':
      self.resnet()
    elif self.model == 'ssd300':
      self.ssd()
    else:
      print('Unknown model:{}'.format(self.model))

    self._bake()

  def ssd(self):
    """Setup ssd benchmark."""
    # Pull benchmark code from git
    git.git_clone('https://github.com/tensorflow/benchmarks.git',
                  os.path.join(self.benchmark_dir,
                               'benchmarks'))

    git.git_clone('https://github.com/tensorflow/models.git',
                  os.path.join(self.benchmark_dir,
                               'models'))

    git.git_clone('https://github.com/cocodataset/cocoapi.git',
                  os.path.join(self.benchmark_dir,
                               'cocoapi'))

    # Download the data
    self._download_from_gcs('gs://mlp_resources/benchmark_data/ssd_gpu',
                            self.disk_dir)


  def ncf(self):
    """Setup ssd benchmark."""
    # Pull benchmark code from git
    git.git_clone('https://github.com/tensorflow/models.git',
                  os.path.join(self.benchmark_dir,
                               'garden'))

    # Download the data
    self._download_from_gcs('gs://mlp_resources/benchmark_data/ssd_gpu',
                            self.disk_dir)


  def resnet(self):
    """Setup resnet benchmark."""
    # Pull benchmark code from git
    git.git_clone('https://github.com/tensorflow/benchmarks.git',
                  os.path.join(self.benchmark_dir,
                               'benchmarks'))

    # Download the data
    self._download_from_gcs('gs://mlp_resources/benchmark_data/nmt_gpu',
                            self.disk_dir)

  def _load_config(self, benchmark_file):
    """Returns config representing the benchmark to run."""
    with open(benchmark_file) as f:
      return yaml.safe_load(f)

  def _download_from_gcs(self, gcs_path, local_destination):
    if self.download:
      cmds = ['gsutil cp -r {} {}'.format(gcs_path, local_destination)]
      local_command.run_list_of_commands(cmds)
    else:
      print('Skipping download: {}'.format(gcs_path))

  def _bake(self):
    """Creates files to run GPU benchmark in bench_dir."""

    # Copies main script into benchmark_dir.
    cmds = []
    cmds.append('mkdir -p {}'.format(self.benchmark_dir))
    cmds.append('cp {} {}/run_helper.sh'.
                format(os.path.join(self.workspace,
                                    self.config['main_script']),
                       self.benchmark_dir))

    # Copies file that will execute during docker build. Suggest backing
    # most of the work into the docker template or in the run script.
    docker_extra_script = 'scripts/setup_docker_noop.sh'
    if 'DOCKER_SCRIPT' in self.config['docker_vars']:
      docker_extra_script = self.config['docker_vars']['DOCKER_SCRIPT']
      # TODO(tobyboyd): config should enforce relative path or put a check
      # in here to handle options like with and without starting with 'scripts'.
      docker_extra_script = 'scripts/' + docker_extra_script

    cmds.append('cp {} {}/docker_setup.sh'.
                format(os.path.join(self.workspace,
                                    docker_extra_script),
                       self.benchmark_dir))

    local_command.run_list_of_commands(cmds)

    with open(os.path.join(self.workspace, 'Dockerfile.tmpl'),
              'r') as docker_tmpl_file:
      docker_tmpl_str = docker_tmpl_file.read()

    with open(os.path.join(self.benchmark_dir, 'Dockerfile'), 'w') as f:
      f.write(docker_tmpl_str.format(
          docker_base=self.config['docker_vars']['DOCKER_FROM']))

    with open(os.path.join(self.benchmark_dir, 'main.sh'), 'w') as f:
      f.write("""#!/bin/bash
set -e
set -o pipefail

MLP_HOST_OUTPUT_DIR=`pwd`/output
mkdir -p $MLP_HOST_OUTPUT_DIR

sudo nvidia-docker build . -t foo
sudo nvidia-docker run -v $MLP_HOST_DATA_DIR:/data \\
-v $MLP_HOST_OUTPUT_DIR:/output -v /proc:/host_proc \\
-t foo:latest /root/run_helper.sh 2>&1 | tee output.txt
""")


def main():
  parser = argparse.ArgumentParser()

  parser.add_argument(
      'benchmark_file',
      type=str,
      help='Path to config file(yaml) for the benchmark.')
  parser.add_argument(
      'benchmark_dir',
      type=str,
      help='Path to store scripts to execute the benchmark.')
  parser.add_argument(
      '--disk_dir',
      type=str,
      default='/data',
      help='Directory of where to create ram disk.')
  parser.add_argument(
      '--ram_disk_size',
      type=int,
      default=0,
      help='If greater than zero create ram disk at disk_dir')
  parser.add_argument(
      '--local_execution',
      type=bool,
      default=False,
      help='Set to true to bake in commands to run outside Kokoro.')
  parser.add_argument(
      '--gce_nvme_raid',
      type=str,
      default=None,
      help='If set create raid 0 array with devices at disk_dir')
  parser.add_argument(
      '--download',
      type=bool,
      default=True,
      help='Set to false to skip download')
  parser.add_argument('--no-download', dest='download', action='store_false')

  flags, _ = parser.parse_known_args()

  benchmark_file = flags.benchmark_file
  benchmark_dir = flags.benchmark_dir

  preflight = Preflight(benchmark_file,
                        benchmark_dir,
                        disk_dir=flags.disk_dir,
                        gce_nvme_raid=flags.gce_nvme_raid,
                        ram_disk_size=flags.ram_disk_size,
                        download=flags.download)

  preflight.execute_preflight()


if __name__ == '__main__':
  main()


