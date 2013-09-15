#!/bin/bash

set -x

RUNNING=$(docker ps |grep sai/haproxy)

[ "$RUNNING" ] && {
    echo "sai/haproxy is already running"
    docker ps
    exit 1
}

echo "sai/haproxy is not running... starting..."

set -e

APACHE1=$(docker run -d sai/apache1)
APACHE2=$(docker run -d sai/apache2)
sleep 2
./pipework.sh br0apache $APACHE1 192.168.200.2
./pipework.sh br0apache $APACHE2 192.168.200.3
HAPROXY=$(docker run -d -p 10001 sai/haproxy)
sleep 2
./pipework.sh br0apache $HAPROXY 192.168.200.1
PORT=$(docker port $HAPROXY 10001)

echo "Use the port $PORT to access from outside"
