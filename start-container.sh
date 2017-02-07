#!/bin/bash

source lib.sh
set -e


# run N slave containers
tag=$1
N=$2

if [[ $# != 2 ]]
then
	echo "Set first parametar as image version tag(e.g. 0.1) and second as number of nodes"
	exit 1
fi

# delete old master container and start new master container
$DOCKER rm -f master &> /dev/null
echo "start master container..."
$DOCKER run -d -t --dns 127.0.0.1 -P --name master -h master.krejcmat.com -w /root krejcmat/hadoop-master:$tag&> /dev/null

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master)

# delete old slave containers and start new slave containers
for i in $(seq 1 $N)
do
	$DOCKER rm -f slave$i &> /dev/null
	echo "start slave$i container..."
	$DOCKER run -d -t --dns 127.0.0.1 -P --name slave$i -h slave$i.krejcmat.com -e JOIN_IP=$FIRST_IP krejcmat/hadoop-slave:$tag &> /dev/null
done 


# create a new Bash session in the master container
$DOCKER exec -it master bash
