
set -e

CMD_FILE=$1
DIR=$2

rm -rf $DIR
cd lib
python -m apparatus.preflight.preflight "$@"

(cd ../$DIR/ && bash ./main.sh)

