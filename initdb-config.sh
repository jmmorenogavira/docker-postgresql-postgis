#!/bin/bash
cat $PGDATA/postgresql.conf | grep '=' | sed 's/ =.*$//;s/^#//' | grep '^[a-z]' | sort | awk '{ print toupper ($0) }' | while read pgvar
do
	eval pgval=\$$pgvar
	if [ x"${pgval}" != "x" ]
	then
		lowcase=$( echo $pgvar | awk '{ print tolower ($0) }')
		echo "$lowcase = $pgval"
	fi
done > $PGDATA/postgresql.docker.conf
cat $PGDATA/postgresql.docker.conf >> $PGDATA/postgresql.conf

