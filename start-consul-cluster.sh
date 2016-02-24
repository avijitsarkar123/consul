#!/bin/bash

# Remove all the existing consul containers (if running)
docker rm -f consul-node1 > /dev/null 2>&1
docker rm -f consul-node2 > /dev/null 2>&1
docker rm -f consul-node3 > /dev/null 2>&1

# Remove the existing registrator container (if running)
docker rm -f registrator > /dev/null 2>&1

# Launch Consul Cluser Node1
docker run -d \
--name consul-node1 \
-h consul-node1 \
-p 8400:8400 -p 8500:8500 -p 8600:53/udp \
progrium/consul \
-server -bootstrap-expect 3 -ui-dir /ui

# Export the Consul IP for clusetr join
CONSUL_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' consul-node1)"

# Launch Consul Cluser Node2
docker run -d \
--name consul-node2 \
-h consul-node2 \
progrium/consul \
-server -join $CONSUL_IP

# Launch Consul Cluser Node3
docker run -d \
--name consul-node3 \
-h consul-node3 \
progrium/consul \
-server -join $CONSUL_IP

# Start Registrator
docker run -d \
-v /var/run/docker.sock:/tmp/docker.sock \
--name registrator -h registrator \
gliderlabs/registrator:latest consul://$CONSUL_IP:8500
