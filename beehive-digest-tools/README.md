# beehive-digest-tools

This container bundles tools used to create sensor data digests from beehive.

## Export Digests (Full)

```sh
docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/recent_datasets:/storage/datasets \
    -v $PWD/recent_digests:/storage/digests \
    beehive-digest-tools:test \
    bash update-recent-digests.sh
```

## Export Digests (Recent)

```sh
docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v $PWD/datasets:/storage/datasets \
    -v $PWD/digests:/storage/digests \
    beehive-digest-tools:test \
    bash update-digests.sh
```
