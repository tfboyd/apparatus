
set -e

CMD_FILE=$1
DIR=$2

rm -rf $DIR
python3 bin/bake_benchmark.py $CMD_FILE $DIR

(cd $DIR/ && bash ./bootstrap.sh)
(cd $DIR/ && bash ./main.sh)

