#!/bin/bash -e

source $(dirname $0)/_du-util.sh

name=postgres

docker run \
       -d \
       --name $name \
       -e POSTGRES_USER=postgres \
       -e POSTGRES_PASSWORD=postgres \
       postgres:latest

print_ips $name
