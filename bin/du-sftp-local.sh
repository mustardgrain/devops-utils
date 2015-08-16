#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=sftp
DOCKER_IMAGE=atmoz/sftp:latest

if [ $# -lt 2 ] ; then
  echo "Usage: $0 <local directory> <user ID> <password>"
  exit 1
fi

local_dir=$1
user_id=$2
password=$3

docker pull $DOCKER_IMAGE
docker run -d --name $TYPE -v $local_dir:/home/$user_id/share $DOCKER_IMAGE $user_id:$password
sleep 15

ip=$(get_docker_ip $TYPE)
echo "SFTP server running at $ip"
