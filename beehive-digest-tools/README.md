# beehive-digest-tools

This container bundles tools used to create sensor data digests from beehive.

## Export Digests (Full)

```sh
docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v /root/.ssh/waggle_id_rsa:/run/secrets/ssh-key:ro \
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
    -v /root/.ssh/waggle_id_rsa:/run/secrets/ssh-key:ro \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    beehive-digest-tools:test \
    bash update-recent-digests.sh
```

This is similar to the full export digests, but will only export data from last 30min. Note that this process doesn't need any data volumes as it's data is ephemeral.

## Bulk (Re)Export Datasets

```sh
docker run -it --rm \
    -e CASSANDRA_HOST=beehive-data.cels.anl.gov \
    -v $PWD/projects:/storage/projects:ro \
    -v $PWD/plugins:/storage/plugins:ro \
    -v /storage/datasets/:/storage/datasets/ \
    -v /storage/digests/:/storage/digests/ \
    beehive-digest-tools \
    bash bulk-export-datasets.sh --start 2018-01-01 --end today
```

This will export the dataset CSVs in the specified time range. The range is specified by providing two of the three arguments:

* `--start`: start date as YYYY-MM-DD or today
* `--end`: end date as YYYY-MM-DD or today
* `--periods`: number of dates

## Important Notes

* There's no simple control for controlling time windows of exports yet. This will be added, though.
* The `sdf.csv` file maintains the mapping between sensor / parameter ID and names. We've never employed proper management for this.
* The beehive plugin system is rough. Basically, the v2 exporter finds all plugins matching `*.plugin/plugin_bin/plugin_beehive`, pipes waggle protocol data through each one, and receives CSV format data. This was never clearly designed and should be consider a hack for now.
* There is no management of plugin IDs right now. It's all just chosen by plugin developer.
* Management of project and plugin directories must be done. These are currently only managed on Github at:
  * [https://github.com/waggle-sensor/beehive-server/tree/master/publishing-tools/projects](https://github.com/waggle-sensor/beehive-server/tree/master/publishing-tools/projects)
  * [https://github.com/waggle-sensor/plugin_manager/tree/master/plugins](https://github.com/waggle-sensor/plugin_manager/tree/master/plugins)
