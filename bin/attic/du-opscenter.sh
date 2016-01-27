#!/bin/bash -e

source $(dirname $0)/_du-util.sh

name=opscenter

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       mustardgrain/opscenter:latest

print_ips $name
echo "OpsCenter web UI running at http://$(get_external_ip $name):8888/"
