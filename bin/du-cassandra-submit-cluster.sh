#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -ne 2 ] ; then
  echo "Usage: $0 <OpsCenter container name> <Cassandra seed container name>"
  exit 1
fi

opscenter_name=$1
seed_name=$2
opscenter_external_ip=$(get_external_ip $opscenter_name)
cassandra_seed_internal_ip=$(get_internal_ip $seed_name)
opscenter_url=http://$opscenter_external_ip:8888
opscenter_config_url=$opscenter_url/cluster-configs

curl \
      $opscenter_config_url \
      -X POST \
      -d \
      "{
          \"cassandra\": {
              \"seed_hosts\": \"$cassandra_seed_internal_ip\"
            },
          \"cassandra_metrics\": {},
          \"jmx\": {
              \"port\": \"7199\"
          }
      }"

echo ""

echo "OpsCenter web UI running at $opscenter_url"
