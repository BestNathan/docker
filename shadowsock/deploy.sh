#!/bin/zsh
password=$1
shadowsockport=$2

printHelp() {
    echo "usage ./shadowsock/deploy.sh password shadowsock-port"
}

if [[ -z $password || -z $shadowsockport ]]
then
    printHelp
    exit 1
fi

docker run \
    -dt \
    --name ssserver \
    -p $shadowsockport:$shadowsockport \
    -p 6500:6500/udp \
    mritd/shadowsocks \
        -m "ss-server" \
        -s "-s 0.0.0.0 -p $shadowsockport -m chacha20 -k $password --fast-open" \
        -x \
        -e "kcpserver" \
        -k "-t 127.0.0.1:$shadowsockport -l :6500 -mode fast2"

echo "deploy success! ss: chacha20. kcp: fast2 6500"