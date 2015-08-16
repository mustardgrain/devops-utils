#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -lt 1 ] ; then
  echo "Usage: $0 <instance group name>"
  exit 1
fi

hosts=$1

if [ "$AWS_ACCESS_KEY" = "" ] ; then
    echo "ERROR: AWS_ACCESS_KEY environment variable not set"
    exit 1
fi

ansible-playbook $PLAYBOOK_DIR/destroy-ec2-instances.yml --extra-vars "hosts=$hosts"
