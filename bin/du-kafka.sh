#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -lt 2 ] ; then
  echo "Usage: $0 <Kafka container name> <num partitions>"
  exit 1
fi

name=$1
num_partitions=${2:-10}
zookeeper_ip=$(get_internal_ip zookeeper)
broker_id=`echo $name | sed -e 's/kafka-//'`

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       -e BROKER_ID=$broker_id \
       -e ZOOKEEPER_CONNECT=$zookeeper_ip:2181 \
       -e NUM_PARTITIONS=$num_partitions \
       mustardgrain/kafka:latest

print_ips $name
