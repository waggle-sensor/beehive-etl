#!/bin/bash -e

docker build -t beehive-digest-tools:test ../beehive-digest-tools

docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/recent_datasets:/storage/datasets \
    -v $PWD/recent_digests:/storage/digests \
    beehive-digest-tools:test \
    bash update-recent-digests.sh
