#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=zookeeper
DOCKER_IMAGE=mustardgrain/$TYPE:latest
run_docker_ec2 $TYPE $TYPE $DOCKER_IMAGE
ip=$(get_public_host $TYPE)
echo "Zookeeper running at $ip"
