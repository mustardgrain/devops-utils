#!/bin/bash -e

source $(dirname $0)/_du-util.sh

if [ $# -ne 3 ] ; then
  echo "Usage: `basename $0` <local directory> <user ID> <password>"
  exit 1
fi

name=sftp
local_dir=$1
user_id=$2
password=$3

docker run \
       -d \
       --name $name \
       -v $local_dir:/home/$user_id/share \
       atmoz/sftp:latest \
       $user_id:$password

print_ips $name
