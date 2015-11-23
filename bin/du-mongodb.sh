#!/bin/bash -e

source $(dirname $0)/util.sh

name=mongodb

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       mustardgrain/mongodb:latest

print_ips $name
