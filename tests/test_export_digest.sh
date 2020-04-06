#!/bin/bash -e

docker build -t workerbee:test ../workerbee

docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/datasets:/storage/datasets \
    -v $PWD/digests:/storage/digests \
    workerbee:test \
    bash update-digests.sh

#find /home/sshahkarami/datasets/ -name '*.csv.gz' | xargs -L1 gzip -dc | head -n 100
