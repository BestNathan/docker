username=$1
password=$2

printHelp() {
    echo "usage ./mongo/deploy/xxx authuser authpass"
}

if [[ -z $username || -z $password ]]
then
    printHelp
    exit 1
fi

mkdir -p /data/mongo/4.0/
chmod -R 777 /data/mongo
docker run \
    --restart always \
    --name mongo4.0 \
    -p :27017 \
    -d \
    -v /data/mongo/4.0/data/db:/data/db \
    -e MONGO_INITDB_ROOT_USERNAME=$username \
    -e MONGO_INITDB_ROOT_PASSWORD=$password \
    mongo:4.0