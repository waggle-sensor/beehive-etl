#!/bin/bash -e

docker build -t workerbee:test ../workerbee

docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/recent_datasets:/storage/datasets \
    -v $PWD/recent_digests:/storage/digests \
    workerbee:test \
    bash update-recent-digests.sh
