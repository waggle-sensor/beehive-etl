#!/bin/bash -e

docker build -t beehive-digest-tools:test ../beehive-digest-tools

docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/datasets:/storage/datasets \
    -v $PWD/digests:/storage/digests \
    beehive-digest-tools:test \
    bash list-keys-v1 --end today --periods 3
