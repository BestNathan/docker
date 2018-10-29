#!/bin/zsh
# usage: ./deploy.sh start
#        ./deploy.sh stop
cmd=$1

if [[ $cmd != "start" && $cmd != "stop" ]]
then
    echo "usage: ./deploy.sh <start|stop>"
    exit 1
fi


start() {
    echo "will start use file: $1"
    docker-compose -f "$1" up -d
    exit 0
}

stop() {
    echo "will kill use file: $1"
    docker-compose -f "$1" kill
    exit 0
}

file="docker-compose.yml"
file1="elasticsearch/${file}"

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