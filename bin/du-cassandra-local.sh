#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=cassandra
DOCKER_IMAGE=mustardgrain/$TYPE:latest

if [ $# -lt 1 ] ; then
  echo "Usage: $0 <instance count>"
  exit 1
fi

count=$1

docker pull $DOCKER_IMAGE

OPS_IP=$(get_docker_ip opscenter)

for i in $(seq 1 $count); do
  name="$TYPE-$i"
  echo "Starting container $name"

  docker run -d --name $name -e OPS_IP=$OPS_IP -e SEED=$SEED_IP $DOCKER_IMAGE
  sleep 60

  if [ $i = 1 ] ; then
    SEED_IP=$(get_docker_ip $name)
  fi
done

submit_cassandra_cluster $OPS_IP $SEED_IP
