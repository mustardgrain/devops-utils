#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=kafka
DOCKER_IMAGE=mustardgrain/$TYPE:latest

if [ $# -ne 1 ] ; then
  echo "Usage: $0 <num partitions>"
  exit 1
fi

num_partitions=$1
zk_ip=$(get_private_host zookeeper)
i=1

for host in $(awk 'NR > 1 { print }' $HOME/.ansible/inventory/$TYPE.public); do
  echo "Starting $TYPE container on $host"

  run_docker_ec2 $TYPE $host $DOCKER_IMAGE "-e BROKER_ID=$i \
                                            -e ZOOKEEPER_CONNECT=$zk_ip:2181 \
                                            -e NUM_PARTITIONS=$num_partitions"

  i=$((i + 1))
done

ip=$(get_public_host $TYPE)
echo "Kafka running at $ip"
