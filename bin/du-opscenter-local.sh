#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=opscenter
DOCKER_IMAGE=mustardgrain/$TYPE:latest
run_docker_singlenode_local $TYPE $DOCKER_IMAGE
ip=$(get_docker_ip $TYPE)
echo "OpsCenter running at http://$ip:8888/"
