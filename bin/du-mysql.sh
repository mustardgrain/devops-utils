#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -ne 4 ] ; then
  echo "Usage: $0 <root password (can be empty)> <database> <database user ID> <database password>"
  exit 1
fi

name=mysql
root_password=$1
db_name=$2
db_user=$3
db_password=$4

if [ "$(is_docker_ec2 $name)" = "true" ] ; then
  eval "$(docker-machine env $name)"
  net="--net host"
fi

docker run \
       -d \
       $net \
       --name $name \
       -e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
       -e MYSQL_ROOT_PASSWORD=$root_password \
       -e MYSQL_DATABASE=$db_name \
       -e MYSQL_USER=$db_user \
       -e MYSQL_PASSWORD=$db_password \
       mysql:5.6

print_ips $name
