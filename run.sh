#!/usr/bin/env bash

set -xe

service ssh start
./sbin/start-all.sh 
echo "Sleeping..."
sleep infinity
