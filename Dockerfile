FROM		postgres:9.5
MAINTAINER	Jose Manuel Moreno Gavira  <josem.moreno.gavira@gmail.com>

ENV		PG_MAJOR	9.5
ENV		POSTGIS_MAJOR 	2.2
ENV		POSTGIS_VERSION	2.2

RUN             apt-get update \
        &&      apt-get install -y --no-install-recommends \
		wget

RUN		echo deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main >> /etc/apt/sources.list
RUN		wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

RUN		apt-get update \
	&&	apt-get install -y --no-install-recommends \
			postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION \
			postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION-scripts \
			postgis \
	&&	rm -rf /var/lib/apt/lists/*

RUN		mkdir -p /docker-entrypoint-initdb.d
COPY		./initdb-postgis.sh	/docker-entrypoint-initdb.d/postgis.sh
COPY		./initdb-config.sh	/docker-entrypoint-initdb.d/config.sh

ENV		POSTGRES_USER			rootuser
ENV		POSTGRES_PASSWORD		rootpass
ENV		POSTGRES_DB			testdb

ENV		MAX_CONNECTIONS			400
ENV		CHECKPOINT_SEGMENTS		3
ENV		DEFAULT_STATISTICS_TARGET	50
ENV		MAINTENANCE_WORK_MEM		448MB
ENV		CONSTRAINT_EXCLUSION		on
ENV		CHECKPOINT_COMPLETION_TARGET	0.9
ENV		EFFECTIVE_CACHE_SIZE		5632MB
ENV		WORK_MEM			9MB
ENV		WAL_BUFFERS			8MB
ENV		CHECKPOINT_SEGMENTS		16
ENV		SHARED_BUFFERS			1792MB


COPY            ./pg_hba.conf           /var/lib/postgresql/data/pg_hba.conf
COPY            ./postgresql.conf	/var/lib/postgresql/data/postgresql.conf
