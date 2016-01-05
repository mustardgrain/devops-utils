#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -lt 2 ] ; then
  echo "Usage: $0 <name> <local directory> <Locust args>"
  exit 1
fi

name=$1
local_dir=$2
locust_arg=$3

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       -e LOCUST_ARGS="$locust_arg" \
       -v $local_dir:/input \
       mustardgrain/locust:latest

print_ips $name
