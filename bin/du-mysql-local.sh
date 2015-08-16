#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -ne 4 ] ; then
  echo "Usage: $0 <root password (can be empty)> <database> <database user ID> <database password>"
  exit 1
fi

root_password=$1
db_name=$2
db_user=$3
db_password=$4

TYPE=mysql
DOCKER_IMAGE=$TYPE:5.6
DOCKER_ARGS=""
DOCKER_ARGS="$DOCKER_ARGS -e MYSQL_ALLOW_EMPTY_PASSWORD=yes"
DOCKER_ARGS="$DOCKER_ARGS -e MYSQL_ROOT_PASSWORD=$root_password"
DOCKER_ARGS="$DOCKER_ARGS -e MYSQL_DATABASE=$db_name"
DOCKER_ARGS="$DOCKER_ARGS -e MYSQL_USER=$db_user"
DOCKER_ARGS="$DOCKER_ARGS -e MYSQL_PASSWORD=$db_password"
run_docker_singlenode_local $TYPE $DOCKER_IMAGE "$DOCKER_ARGS"
ip=$(get_docker_ip $TYPE)
echo "MySQL running at $ip"
