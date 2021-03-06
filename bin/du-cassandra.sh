#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -lt 1 ] ; then
  echo "Usage: `basename $0` <Cassandra container name> <Cassandra seed container name>"
  exit 1
fi

name=$1
seed_name=${2:-$1}

if [ "$name" = "$seed_name" ] ; then
  # Leave this setting blank intentionally so that the seed
  # will default to the current container's IP address
  cassandra_seed_ip=
else
  cassandra_seed_ip=$(get_internal_ip $seed_name)
fi

docker run \
       -d \
       --name $name \
       -e SEED=$cassandra_seed_ip \
       mustardgrain/cassandra:latest

print_ips $name
