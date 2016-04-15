#!/bin/bash -e

source $(dirname $0)/_du-util.sh

name=zookeeper

docker run \
       -d \
       --name $name \
       mustardgrain/zookeeper:latest

print_ips $name
