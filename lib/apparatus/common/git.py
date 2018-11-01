"""Git helper."""
from __future__ import print_function
import os

import apparatus.common.local_command as local_command


def git_clone(git_repo, local_folder, branch=None, sha_hash=None):
  """Clone, update, or synce a repo.

  If the clone already exists the repo will be updated via a pull.

  Args:
    git_repo (str): Command to
    local_folder (str): Where to clone repo into.
    branch (str, optional): Branch to checkout.
    sha_hash (str, optional): Hash to sync to.
  """
  if os.path.isdir(local_folder):
    git_clone_or_pull = 'git -C {} pull'.format(local_folder)
  else:
    git_clone_or_pull = 'git clone {} {}'.format(git_repo, local_folder)
  local_command.run_local_command(git_clone_or_pull)

  if branch is not None:
    branch_cmd = 'git -C {} checkout {}'.format(local_folder, branch)
    local_command.run_local_command(branch_cmd)

  if sha_hash is not None:
    sync_to_hash_cmd = 'git -C {} reset --hard {}'.format(
        local_folder, sha_hash)
    local_command.run_local_command(sync_to_hash_cmd)
