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

## Important Notes

* There's no simple control for controlling time windows of exports yet. This will be added, though.
* The `sdf.csv` file maintains the mapping between sensor / parameter ID and names. We've never employed proper management for this.
* The beehive plugin system is rough. Basically, the v2 exporter finds all plugins matching `*.plugin/plugin_bin/plugin_beehive`, pipes waggle protocol data through each one, and receives CSV format data. This was never clearly designed and should be consider a hack for now.
* There is no management of plugin IDs right now. It's all just chosen by plugin developer.
