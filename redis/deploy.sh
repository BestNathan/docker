#!/bin/zsh
password=$1

printHelp() {
    echo "usage ./redis/deploy.sh requirepass"
}

if [[ -z $password ]]
then
    printHelp
    exit 1
fi

mkdir -p /data/redis/
chmod -R 777 /data/redis
docker run \
    --restart always \
    --name redis \
    -p :6379 \
    -d \
    -v /data/redis/data:/data \
    redis \
        redis-server \
            --appendonly yes \
            --requirepass $password \
