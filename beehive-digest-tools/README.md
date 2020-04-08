# beehive-digest-tools

This container bundles tools used to create sensor data digests from beehive.

## Export Digests (Full)

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

This command does the following:

1. Update dataset CSVs from last 3 days. For v2 plugins, will decode using all `*.plugin/plugin_bin/plugin_beehive` executables.
2. For each project, compile datasets into digests directory.

## Export Digests (Recent)

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

This is similar to the full export digests, but will only export data from last 30min.
