#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=elasticsearch
DOCKER_IMAGE=mustardgrain/$TYPE:latest

if [ $# -lt 1 ] ; then
  echo "Usage: $0 <instance count>"
  exit 1
fi

count=$1

docker pull $DOCKER_IMAGE

for i in $(seq 1 $count); do
  name="$TYPE-$i"
  echo "Starting container $name"

  docker run -d --name $name -e MASTER_IP=$MASTER_IP -e ES_HEAP_SIZE=4g $DOCKER_IMAGE
  sleep 15

  if [ $i = 1 ] ; then
    MASTER_IP=$(get_docker_ip $name)
  fi
done

echo "Go to http://$MASTER_IP:9200/_plugin/marvel/ to view cluster status"
