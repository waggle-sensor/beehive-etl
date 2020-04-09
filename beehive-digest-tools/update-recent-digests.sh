#!/bin/bash

WINDOW=1800 # 30min

function compile() {
  mkdir -p /storage/datasets/v1 /storage/datasets/v2 /storage/plugins
  rm -rf /storage/datasets/v1/* /storage/datasets/v2/* /storage/digests/*

  python list-datasets-v1 | python filter-last-day | python export-recent-datasets-v1 --since $WINDOW -p 8 /storage/datasets/v1

  # TODO figure out how to handle sdf / beehive plugins
  # TODO look into what the -p support is
  python list-datasets-v2 | python filter-last-day | python export-recent-datasets-v2 --since $WINDOW /storage/datasets/v2 $PWD/sdf.csv /storage/plugins/*.plugin

  # For now, we're only supporting complete digests. AoT_Chicago.public was the only example and was no used AFAIK.
  for p in $(ls /storage/projects | grep .complete); do
    echo "compile $p -- complete"
    ./compile-digest-v2 --no-cleanup --complete --data /storage/datasets/v1 --data /storage/datasets/v2 /storage/digests /storage/projects/$p
  done
}

function upload() {
  target='aotpub:/mcs/www.mcs.anl.gov/research/projects/waggle/downloads/datasets'

  for p in $(ls /storage/digests); do
    echo "upload $p - start"
    gzip -c -d /storage/digests/$p/data.csv.gz > /storage/digests/$p/data.csv
    src=/storage/digests/$p/data.csv
    dst=$target/$p.recent.csv
    scp $src $dst

    src=/storage/digests/$p/$p.latest.tar
    dst=$target/$p.recent.tar
    if scp $src $dst; then
      echo "upload $p - done"
    else
      echo "upload $p - error"
    fi
  done
}

echo "exporting rececnt digests from ${CASSANDRA_HOST}"
compile
# upload
