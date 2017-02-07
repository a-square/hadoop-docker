#!/bin/bash

source lib.sh
set -e


image=$1
tag='latest'


if [[ -z $image ]]
then
	echo "Please use image name as the first argument!"
	exit 1
fi

# function for delete images
function docker_rmi()
{
	echo -e "\n\n$DOCKER rmi krejcmat/$1:$tag"
	$DOCKER rmi krejcmat/$1:$tag || true
}


# function for build images
function docker_build()
{
	pushd $1
	echo -e "\n\n$DOCKER build -t krejcmat/$1:$tag ."
	$TIME $DOCKER build -t krejcmat/$1:$tag .
	popd
}

function cleanup()
{
	rm -f images.txt
}

echo -e "\ndocker rm -f slave1 slave2 master"
$DOCKER rm -f slave1 slave2 master || true

$DOCKER images >images.txt
trap cleanup EXIT

#all image is based on dnsmasq. master and slaves are based on base image.
if [[ $image == "hadoop-dnsmasq" ]]
then
	docker_rmi hadoop-master
	docker_rmi hadoop-slave
	docker_rmi hadoop-base
	docker_rmi hadoop-dnsmasq
	docker_build hadoop-dnsmasq
	docker_build hadoop-base
	docker_build hadoop-master
	docker_build hadoop-slave 
elif [[ $image == "hadoop-base" ]]
then
	docker_rmi hadoop-master
	docker_rmi hadoop-slave
	docker_rmi hadoop-base
	docker_build hadoop-base
	docker_build hadoop-master
	docker_build hadoop-slave
elif [[ $image == "hadoop-master" ]]
then
	docker_rmi hadoop-master
	docker_build hadoop-master
elif [[ $image == "hadoop-slave" ]]
then
	docker_rmi hadoop-slave
	docker_build hadoop-slave
else
	echo "The image name is wrong!"
fi

#docker_rmi hadoop-base

echo -e "\nimages before build"
cat images.txt

echo -e "\nimages after build"
$DOCKER images
