#!/bin/bash

WINDOW=1800 # 30min

mkdir -p /storage/datasets/v1 /storage/datasets/v2 /storage/plugins
rm -rf /storage/datasets/v1/* /storage/datasets/v2/* /storage/digests/*

echo "exporting recent v1 digests from ${CASSANDRA_HOST}"
python list-keys-v1 --end today --periods 2 | python export-recent-datasets-v1 --since $WINDOW -p 8 /storage/datasets/v1

# TODO figure out how to handle sdf / beehive plugins
# TODO look into what the -p support is
echo "exporting recent v2 digests from ${CASSANDRA_HOST}"
python list-keys-v2 --end today --periods 2 | python export-recent-datasets-v2 --since $WINDOW /storage/datasets/v2 $PWD/sdf.csv /storage/plugins/*.plugin

# For now, we're only supporting complete digests. AoT_Chicago.public was the only example and was no used AFAIK.
for projectpath in /storage/projects/*.complete; do
  project=$(basename $projectpath)
  echo "compile $project -- complete"
  ./compile-digest-v2 --no-cleanup --complete --data /storage/datasets/v1 --data /storage/datasets/v2 "/storage/digests/$project/" "/storage/projects/$project"
  echo "uploading $project"
  gzip -d "/storage/digests/$project/data.csv.gz"

  # rename files for remote
  mv "/storage/digests/$project/data.csv" "/storage/digests/$project/$project.recent.csv"
  mv "/storage/digests/$project/$project.latest.tar" "/storage/digests/$project/$project.recent.tar"
  # upload files
  rsync -av --stats --partial-dir='.partial/' \
    "/storage/digests/$project/$project.recent.csv" \
    "/storage/digests/$project/$project.recent.tar" \
    'aotpub:/mcs/www.mcs.anl.gov/research/projects/waggle/downloads/datasets/'
done
