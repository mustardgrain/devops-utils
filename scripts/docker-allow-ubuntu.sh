#!/bin/bash -e

sudo gpasswd -a ubuntu docker
sudo service docker restart

