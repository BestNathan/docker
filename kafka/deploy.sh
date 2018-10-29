#!/bin/zsh
# usage: ./deploy.sh start 127.0.0.1
#        ./deploy.sh stop
cmd=$1
kafka_host_name=$2

if [[ -z $cmd || ($cmd != "start" && $cmd != "stop") ]]
then
    echo "usage: ./deploy.sh <start|stop>"
    exit 1
fi


if [[ $cmd = "start" && -z $kafka_host_name ]]
then
    echo "usage: ./deploy.sh start <kafka_host_name>"
    exit 1
fi

start() {
    export DOCKER_KAFKA_ADVERTISED_HOST_NAME=$kafka_host_name
    echo "will start use file: $1, kafka_host_name: $DOCKER_KAFKA_ADVERTISED_HOST_NAME"
    docker-compose -f "$1" up -d
    exit 0
}

stop() {
    export DOCKER_KAFKA_ADVERTISED_HOST_NAME="temp"
    echo "will kill use file: $1"
    docker-compose -f "$1" kill
    exit 0
}

file="docker-compose.yml"
file1="kafka/${file}"

if [ -f "$file" ]; then
    if [ $cmd = "stop" ]
    then
        stop $file
    else
        start $file
    fi
fi 

if [ -f "$file1" ]; then 
    if [ $cmd = "stop" ]
    then
        stop $file1
    else
        start $file1
    fi
fi 