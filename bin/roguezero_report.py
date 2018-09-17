#!/usr/bin/env python

import sys
import os


def main():
    os.system('rm -rf /tmp/py3_rogue_env')
    os.system('python3 -m venv /tmp/py3_rogue_env')
    os.system('. /tmp/py3_rogue_env/bin/activate; pip3 install google-cloud google-cloud-bigquery')

    helper_path = sys.argv[0]
    helper_path = helper_path.replace('rogue', 'helper_rogue')
    dirpath= sys.argv[1]


    cmd = '. /tmp/py3_rogue_env/bin/activate; python3 {} {}'.format(helper_path, dirpath)
    print(cmd)
    os.system(cmd)


if __name__ == '__main__':
    main()

