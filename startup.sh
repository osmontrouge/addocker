#!/bin/bash

function no_redis {
  echo No connection to redis. Exiting.
  exit 1
}

function get_import_date {
  redis-cli -h redis get import_date
}

function wait_loading {
  while [ $( get_import_date ) -eq "LOADING" ]; do
    echo "Sleeping"
    sleep 1s
  done
}

redis-cli -h redis ping > /dev/null || no_redis
import_date=$( get_import_date )
address_source=$( redis-cli -h redis get address_source )

if [ -z "$import_date" ]; then
cat << EOF
It seems that no data was imported.
If it is the first run, this is normal.

If you want to import the data from an url, execute on you host:
> docker-compose run addock-api import.sh https://bano.openstreetmap.fr/data/full.sjson.gz

If you prefer to use a local file, copy it to ./addok-data
> docker-compose run addock-api import.sh filename.sjson.gz

I will now run addok and it will be ready once the import is done.
EOF
else
cat << EOF
Running addok
Last import: $import_date
Address data used: $address_source
EOF
fi

gunicorn addok.http.wsgi -b 0.0.0.0:7878
