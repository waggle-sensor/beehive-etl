#!/bin/bash

echo "exporting v1 digests from ${CASSANDRA_HOST}"
python list-keys-v1 --end today --periods 3 | python export-datasets-v1 /storage/datasets/v1

# TODO figure out how to handle sdf / beehive plugins
# TODO look into what the -p support is
echo "exporting v2 digests from ${CASSANDRA_HOST}"
python list-keys-v2 --end today --periods 3 | python export-datasets-v2 /storage/datasets/v2 $PWD/sdf.csv /storage/plugins/*.plugin

# For now, we're only supporting complete digests. AoT_Chicago.public was the only example and was no used AFAIK.
for projectpath in /storage/projects/*.complete; do
  project=$(basename $projectpath)
  echo "compile $project -- complete"
  ./compile-digest-v2 --complete --data /storage/datasets/v1 --data /storage/datasets/v2 "/storage/digests/$project/" "/storage/projects/$project"
  # generate checksum
  tarfile="/storage/digests/$project/$project.latest.tar"
  echo "generating checksum for ${tarfile}"
  shasum -a 256 "${tarfile}" > "${tarfile}.sha256"
  echo "generating metadata for ${tarfile}"
  hostname > "${tarfile}.hostname"
  echo "uploading ${project}"
  rsync -av --stats --partial-dir='.partial' \
    "${tarfile}" \
    "${tarfile}.sha256" \
    "${tarfile}.hostname" \
    'aotpub:/mcs/www.mcs.anl.gov/research/projects/waggle/downloads/datasets/'
done
