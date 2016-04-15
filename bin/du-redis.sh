#!/bin/bash -e

source $(dirname $0)/_du-util.sh

name=redis

docker run \
       -d \
       --name $name \
       mustardgrain/redis:latest

print_ips $name
