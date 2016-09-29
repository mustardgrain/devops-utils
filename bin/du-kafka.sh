#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -lt 1 ] ; then
  echo "Usage: `basename $0` <Kafka container name> [<num partitions>]"
  exit 1
fi

name=$1
num_partitions=${2:-1}
zookeeper_ip=$(get_internal_ip zookeeper)
broker_id=`echo $name | sed -e 's/kafka-//'`

docker run \
       -d \
       --name $name \
       -e BROKER_ID=$broker_id \
       -e ZOOKEEPER_CONNECT=$zookeeper_ip:2181 \
       -e NUM_PARTITIONS=$num_partitions \
       mustardgrain/kafka:latest

print_ips $name
