#!/bin/bash

function download_and_gunzip {
  curl $1 | gunzip > addresses.json || exit
  echo addresses.json
}

function file_gunzip {
  gunzip "/data/$1"
  echo /data/$( basename "/data/$1" .gz )
}

if [ $# -eq 1 ]; then
  if [[ $1 == http* ]]; then
    filename=$( download_and_gunzip $1 )
  else
    filename=$( file_gunzip $1 )
  fi
  addok batch $filename
  redis-cli -h redis set import_date "$( date )"
  redis-cli -h redis set address_source "$1"
else
  echo "Please provide the url or path of database in the json.gz format"
fi
