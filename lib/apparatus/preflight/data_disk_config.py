"""Setup the data drive with raid, RAM, or mount network drives."""
from __future__ import print_function

import apparatus.common.local_command as local_command


def create_gce_nvme_raid(data_dir, list_of_devices):
  """Creates a raid zero array of nvme drives."""

  cmd = 'sudo mountpoint -q {}'.format(data_dir)
  retcode, _ = local_command.run_local_command(cmd)
  if retcode:
    cmds = []
    cmds.append('sudo mdadm --create /dev/md0 --level=0 '
                '--raid-devices={} {}'.format(len(list_of_devices),
                                              ' '.join(list_of_devices)))
    cmds.append('sudo mkfs.ext4 -F /dev/md0')
    cmds.append('sudo mkdir -p {}'.format(data_dir))
    cmds.append('sudo mount /dev/md0 {}'.format(data_dir))
    cmds.append('sudo chmod a+w {}'.format(data_dir))

    local_command.run_list_of_commands(cmds)
  else:
    print('RAID array or something else is mounted at {}'.format(data_dir))


def create_ram_disk(data_dir, disk_size):
  """Create a RAM disk."""

  cmd = 'sudo mountpoint -q {}'.format(data_dir)
  retcode, _ = local_command.run_local_command(cmd)
  if retcode:
    cmds = []
    cmds.append('sudo mkdir -p {}'.format(data_dir))
    cmds.append('sudo mount -t tmpfs -o size={}m tmpfs {}'.
                format(disk_size, data_dir))

    local_command.run_list_of_commands(cmds)
  else:
    print('RAM disk or something else is mounted at {}'.format(data_dir))

