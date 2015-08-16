#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=kafka
DOCKER_IMAGE=mustardgrain/$TYPE:latest

if [ $# -ne 2 ] ; then
  echo "Usage: $0 <instance count> <num partitions>"
  exit 1
fi

count=$1
num_partitions=$2

docker pull $DOCKER_IMAGE

ZK_IP=$(get_docker_ip zookeeper)

for i in $(seq 1 $count); do
  name="$TYPE-$i"
  echo "Starting container $name"

  docker run -d --name $name -e BROKER_ID=$i -e ZOOKEEPER_CONNECT=$ZK_IP:2181 -e NUM_PARTITIONS=$num_partitions $DOCKER_IMAGE
  sleep 15

  if [ $i = 1 ] ; then
    MASTER_IP=$(get_docker_ip $name)
  fi
done


echo "Kafka server running at $MASTER_IP"
