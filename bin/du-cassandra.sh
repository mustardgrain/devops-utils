#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -lt 1 ] ; then
  echo "Usage: $0 <Cassandra container name> <Cassandra seed container name>"
  exit 1
fi

name=$1
seed_name=${2:-$1}
opscenter_ip=$(get_internal_ip opscenter)

if [ "$name" = "$seed_name" ] ; then
  # Leave this setting blank intentionally so that the seed
  # will default to the current container's IP address
  cassandra_seed_ip=
else
  cassandra_seed_ip=$(get_internal_ip $seed_name)
fi

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       -e SEED=$cassandra_seed_ip \
       -e OPS_IP=$opscenter_ip \
       mustardgrain/cassandra:latest

print_ips $name
