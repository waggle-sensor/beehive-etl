#!/bin/bash

WINDOW=1800 # 30min

function compile() {
  echo "exporting recent digests from ${CASSANDRA_HOST}"

  mkdir -p /storage/datasets/v1 /storage/datasets/v2 /storage/plugins
  rm -rf /storage/datasets/v1/* /storage/datasets/v2/* /storage/digests/*

  python list-keys-v1 --end today --periods 2 | python export-recent-datasets-v1 --since $WINDOW -p 8 /storage/datasets/v1

  # TODO figure out how to handle sdf / beehive plugins
  # TODO look into what the -p support is
  python list-keys-v2 --end today --periods 2 | python export-recent-datasets-v2 --since $WINDOW /storage/datasets/v2 $PWD/sdf.csv /storage/plugins/*.plugin

  # For now, we're only supporting complete digests. AoT_Chicago.public was the only example and was no used AFAIK.
  for p in $(ls /storage/projects | grep .complete); do
    echo "compile $p -- complete"
    ./compile-digest-v2 --no-cleanup --complete --data /storage/datasets/v1 --data /storage/datasets/v2 /storage/digests /storage/projects/$p
  done
}

function upload() {
  target='aotpub:/mcs/www.mcs.anl.gov/research/projects/waggle/downloads/datasets'
  echo "uploading recent digests to ${target}"

  for projectpath in /storage/projects/*.complete; do
    project=$(basename $projectpath)
    echo "uploading $project @ $projectpath"
    gzip -c -d /storage/digests/$project.latest/*/data.csv.gz > "/storage/digests/$project.latest.csv"
    scp "/storage/digests/$project.latest.csv" "$target/$project.recent.csv"
    scp "/storage/digests/$project.latest.tar" "$target/$project.recent.tar"
  done
}

compile
upload
