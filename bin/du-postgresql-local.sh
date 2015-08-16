#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=postgres
DOCKER_IMAGE=$TYPE:latest
run_docker_singlenode_local $TYPE $DOCKER_IMAGE "-e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres"
ip=$(get_docker_ip $TYPE)
echo "PostgreSQL running at $ip"
