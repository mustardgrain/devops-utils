#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=redis
DOCKER_IMAGE=mustardgrain/$TYPE:latest
run_docker_ec2 $TYPE $DOCKER_IMAGE
ip=$(get_public_host $TYPE)
echo "Redis running at $ip"
