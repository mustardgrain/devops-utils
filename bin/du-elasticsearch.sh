#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -lt 1 ] ; then
  echo "Usage: `basename $0` <Elasticsearch container name> <Elasticsearch master container name>"
  exit 1
fi

name=$1
master_name=${2:-$1}

if [ "$name" = "$master_name" ] ; then
  # Leave this setting blank intentionally so that the master
  # will default to the current container's IP address
  master_ip=
else
  master_ip=$(get_internal_ip $master_name)
fi

docker run \
       -d \
       --name $name \
       -e MASTER_IP=$master_ip \
       -e ES_HEAP_SIZE=4g \
       mustardgrain/elasticsearch:latest

print_ips $name
echo "Elasticsearch running at http://$(get_internal_ip $master_name):9200/"
