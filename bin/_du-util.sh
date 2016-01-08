#!/bin/bash -e

function is_docker_ec2() {
  container=$1
  count=`docker-machine ls | grep $container | grep amazonec2 | wc -l`

  if [ $count -gt 0 ] ; then
    echo "true"
  else
    echo "false"
  fi
}

function get_external_ip() {
  container=$1

  if [ "$(is_docker_ec2 $container)" = "true" ] ; then
    docker-machine ip $container
  else
    ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)
  fi

  return_code=$?

  if [ $return_code = 0 ] ; then
    echo $ip
  else
    exit 2
  fi
}

function get_internal_ip() {
  container=$1

  if [ "$(is_docker_ec2 $container)" = "true" ] ; then
    ip=$(docker-machine inspect -f '{{ .Driver.PrivateIPAddress }}' $container)
  else
    ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)
  fi

  return_code=$?

  if [ $return_code = 0 ] ; then
    echo $ip
  else
    exit 2
  fi
}

function print_ips() {
  name=$1

  if [ "$(is_docker_ec2 $name)" = "true" ] ; then
    echo "$name running at $(get_internal_ip $name) (internal)/$(get_external_ip $name) (external)"
  else
    echo "$name running at $(get_internal_ip $name)"
  fi
}
