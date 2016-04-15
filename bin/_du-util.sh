#!/bin/bash -e

function get_internal_ip() {
  container=$1
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)
  return_code=$?

  if [ $return_code = 0 ] ; then
    echo $ip
  else
    exit 2
  fi
}

function print_ips() {
  container=$1
  echo "$container running at $(get_internal_ip $container)"
}
