#!/bin/bash -e

source $(dirname $0)/_du-util.sh

name=zookeeper

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       mustardgrain/zookeeper:latest

print_ips $name
