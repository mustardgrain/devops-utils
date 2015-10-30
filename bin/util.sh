#!/bin/bash -e

function get_abs_path() {
  cd $1
  pwd
}

function get_public_host() {
  hosts=$1
  cat $HOME/.ansible/inventory/$hosts.public | tail -n 1
}

function get_private_host() {
  hosts=$1
  cat $HOME/.ansible/inventory/$hosts.private | tail -n 1
}

function get_docker_ip() {
  container=$1
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)
  return_code=$?

  if [ $return_code = 0 ] ; then
    echo $ip
  else
    exit 2
  fi
}

function run_script() {
  hosts=$1
  script=$2

  chmod +x $script
  ansible-playbook $PLAYBOOK_DIR/run-script.yml --extra-vars "hosts=$hosts script_path=$script"
  rm $script
}

function run_docker_singlenode_local() {
  TYPE=$1
  DOCKER_IMAGE=$2
  DOCKER_ARGS=$3

  docker pull $DOCKER_IMAGE

  echo "Starting container $TYPE with image $DOCKER_IMAGE and extra args: $DOCKER_ARGS"

  docker run -d --name $TYPE $DOCKER_ARGS $DOCKER_IMAGE
  sleep 15
}

function run_docker_ec2() {
  TYPE=$1
  HOST_OR_GROUP=$2
  DOCKER_IMAGE=$3
  DOCKER_ARGS=$4

  TMP_SCRIPT=/tmp/run-$TYPE-script.sh

  cat << WRITE_TMP_SCRIPT > $TMP_SCRIPT
#!/bin/bash

try=1

while [ \$try -lt 5 ] ; do
  # Kill everything, running or not
  docker ps -a | grep -v "CONTAINER" | awk '{print \$1}' | xargs docker stop
  docker ps -a | grep -v "CONTAINER" | awk '{print \$1}' | xargs docker rm

  docker pull $DOCKER_IMAGE
  docker run \
      -d \
      --net host \
      $DOCKER_ARGS \
      --name $TYPE \
      $DOCKER_IMAGE

  return_code=\$?

  if [ \$return_code = 0 ] ; then
    break
  else
    try=\$[\$try + 1]
  fi
done

if [ \$return_code != 0 ] ; then
  echo "Starting Docker failed after \$try tries"
  exit 1
else
  echo "Starting Docker successful after \$try tries"
fi
WRITE_TMP_SCRIPT

  run_script $HOST_OR_GROUP $TMP_SCRIPT
}

function submit_cassandra_cluster() {
  opscenter_host=$1
  cassandra_seed=$2

  opscenter_url=http://$opscenter_host:8888
  opscenter_config_url=$opscenter_url/cluster-configs

  curl \
        $opscenter_config_url \
        -X POST \
        -d \
        "{
            \"cassandra\": {
                \"seed_hosts\": \"$cassandra_seed\"
              },
            \"cassandra_metrics\": {},
            \"jmx\": {
                \"port\": \"7199\"
            }
        }"

  echo "Cassandra seed: $cassandra_seed"
  echo "Go to $opscenter_url to view OpsCenter"
}

export SCRIPTS_DIR=$(get_abs_path $(dirname $0)/../scripts)
export PLAYBOOK_DIR=$(get_abs_path $(dirname $0)/../ansible/playbooks)
