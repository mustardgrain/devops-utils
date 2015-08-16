#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=opscenter
DOCKER_IMAGE=mustardgrain/$TYPE:latest
run_docker_ec2 $TYPE $DOCKER_IMAGE
ip=$(get_public_host $TYPE)
echo "OpsCenter running at http://$ip:8888/"
