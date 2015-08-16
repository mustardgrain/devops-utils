#!/bin/bash
#
# this script will attempt to detect any ephemeral drives on an EC2 node and create a RAID-0 stripe
# mounted at /mnt. It should be run early on the first boot of the system.
#
# Beware, This script is NOT fully idempotent.
#
# Thanks to Joe Miller: https://gist.github.com/joemiller/6049831

METADATA_URL_BASE="http://169.254.169.254/latest"

# Configure Raid - take into account xvdb or sdb
root_drive=`df -h | grep -v grep | awk 'NR==2{print $1}'`

if [ "$root_drive" == "/dev/xvda1" ]; then
  DRIVE_SCHEME='xvd'
else
  DRIVE_SCHEME='sd'
fi

# figure out how many ephemerals we have by querying the metadata API, and then:
#  - convert the drive name returned from the API to the hosts DRIVE_SCHEME, if necessary
#  - verify a matching device is available in /dev/
ephemerals=$(curl --silent $METADATA_URL_BASE/meta-data/block-device-mapping/ | grep ephemeral)

for e in $ephemerals; do
  device_name=$(curl --silent $METADATA_URL_BASE/meta-data/block-device-mapping/$e)
  # might have to convert 'sdb' -> 'xvdb'
  device_name=$(echo $device_name | sed "s/sd/$DRIVE_SCHEME/")
  device_path="/dev/$device_name"

  # test that the device actually exists since you can request more ephemeral drives than are available
  # for an instance type and the meta-data API will happily tell you it exists when it really does not.
  if [ -b $device_path ]; then
    echo "$device_path"
    drives="$drives $device_path"
    ephemeral_count=$((ephemeral_count + 1 ))
  fi
done
