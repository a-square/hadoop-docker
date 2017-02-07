#!/bin/bash

source lib.sh
set -e


tag="latest"

# N is the node number of the cluster
N=$1

if [[ -z $N ]]
then
	echo "Please use the node number of the cluster as the argument!"
	exit 1
fi

cd hadoop-master

# change the slaves file
echo "master.krejcmat.com" > files/slaves
for i in $(seq 1 $N)
do
	echo "slave$i.krejcmat.com" >> files/slaves
done 

# delete master container
$DOCKER rm -f master 

# delete hadoop-master image
$DOCKER rmi krejcmat/hadoop-master:$tag 

# rebuild hadoop-docker image
pwd
$DOCKER build -t krejcmat/hadoop-master:$tag .
