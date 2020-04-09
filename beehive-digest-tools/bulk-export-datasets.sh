#!/bin/bash

if [ -z "$*" ]; then
  echo "export range is specified by choosing two of the following three args:"
  echo "  --start date"
  echo "  --end date"
  echo "  --periods n"
  exit 1
fi

echo "exporting v1 digests from ${CASSANDRA_HOST}"
python list-keys-v1 $* | python export-datasets-v1 -p 8 /storage/datasets/v1

# TODO figure out how to handle sdf / beehive plugins
# TODO look into what the -p support is
echo "exporting v2 digests from ${CASSANDRA_HOST}"
python list-keys-v2 $* | python export-datasets-v2 /storage/datasets/v2 $PWD/sdf.csv /storage/plugins/*.plugin
