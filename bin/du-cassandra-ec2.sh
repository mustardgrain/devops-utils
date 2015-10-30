#!/bin/bash -e

source $(dirname $0)/util.sh

TYPE=cassandra
DOCKER_IMAGE=mustardgrain/$TYPE:latest
DATA_DIR=/mnt/cassandra/data
COMMIT_LOG_DIR=/mnt/cassandra/commitlog
ops_ip=$(get_public_host opscenter)
seed_ip=$(get_private_host $TYPE)
run_docker_ec2 $TYPE $TYPE $DOCKER_IMAGE "-v $DATA_DIR:$DATA_DIR \
                                          -v $COMMIT_LOG_DIR:$COMMIT_LOG_DIR \
                                          -e DATA_DIR=$DATA_DIR \
                                          -e COMMIT_LOG_DIR=$COMMIT_LOG_DIR \
                                          -e SEED=$seed_ip \
                                          -e OPS_IP=$ops_ip"
sleep 120
submit_cassandra_cluster $ops_ip $seed_ip
