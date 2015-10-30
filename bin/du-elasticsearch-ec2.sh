#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=elasticsearch
DOCKER_IMAGE=mustardgrain/$TYPE:latest
private_ip=$(get_private_host $TYPE)
run_docker_ec2 $TYPE $TYPE $DOCKER_IMAGE "-e MASTER_IP=$private_ip"
ip=$(get_public_host $TYPE)
echo "Go to http://$ip:9200/_plugin/marvel/ to view cluster status"
