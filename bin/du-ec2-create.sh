#!/bin/bash -e

source $(dirname $0)/util.sh

if [ $# -lt 3 ] ; then
  echo "Usage: $0 <instance group name> <instance size> <instance count>"
  exit 1
fi

hosts=$1
size=$2
count=$3

if [ "$AWS_ACCESS_KEY" = "" ] ; then
    echo "ERROR: AWS_ACCESS_KEY environment variable not set"
    exit 1
fi

ansible-playbook $PLAYBOOK_DIR/launch-ec2-instances.yml --extra-vars "instance_count=$count instance_type=$size instance_group_name=$hosts"
ansible-playbook $PLAYBOOK_DIR/raid.yml --extra-vars "hosts=$hosts"
ansible-playbook $PLAYBOOK_DIR/run-script.yml --extra-vars "hosts=$hosts script_path=$SCRIPTS_DIR/docker-install.sh"
ansible-playbook $PLAYBOOK_DIR/run-script.yml --extra-vars "hosts=$hosts script_path=$SCRIPTS_DIR/docker-allow-ubuntu.sh"
