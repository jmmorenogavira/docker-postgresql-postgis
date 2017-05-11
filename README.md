# docker-postgresql-postgis

The `postgresql-postgis` image provides a Docker container running Postgres 9.5 with
[PostGIS 2.2](http://postgis.net/docs/manual-2.2/) installed.

The PostGIS extension can be installed into your database in 
[the standard way](http://postgis.net/docs/postgis_installation.html#create_new_db_extensions) via `psql`:

	CREATE EXTENSION postgis;
	CREATE EXTENSION postgis_topology;

## Usage

In order to run a basic container capable of serving a PostGIS-enabled database,
start a container as follows:

    docker run --name some-postgis -e MAX_CONNECTIONS=400 -d jmmoreno/docker-postgresql-postgis

For more detailed instructions about how to start and control your Postgres
container, see the documentation for the `postgres` image
[here](https://registry.hub.docker.com/_/postgres/).

Once you have started a database container, you can then connect to the
database as follows:

    docker run -it --link some-postgis:postgres --rm postgres \
        sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

Using the resulting `psql` shell, you can create a PostGIS-enabled database by
using the `CREATE EXTENSION` mechanism:


	CREATE EXTENSION postgis;
	CREATE EXTENSION postgis_topology;


See [the PostGIS documentation](http://postgis.net/docs/postgis_installation.html#create_new_db_extensions)
for more details on your options for creating and using a spatially-enabled database.

## Configuration (environment variables)

For the first run, one database could be created if next environment variables are supplied:

* `POSTGRES_USER` - creates an user with full privileges.
* `POSTGRES_PASSWORD` - password for `POSTGRES_USER`.
* `POSTGRES_DB` - default database for `POSTGRES_USER`.

## Data persistence

If you want to make your data persistent, you need to mount a volume:

	docker run ....... -v /opt/db/postgresql/data:/var/lib/postgresql/data .....

in order to make sure that everything is restored after a restart of the container (databases, configuration, ...).