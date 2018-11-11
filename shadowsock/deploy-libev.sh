# first setup parameters
serverip=$(/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|head -1)

echo ""
echo "usage: command -p[8888] -P[nathan] -m[rc4-md5] -h[$serverip] -k[6666]"
echo "will setup shadowsock with serverip: $serverip"
echo "if server ip is not correct, please use -h"
echo ""

while getopts "p:P:m:h:k:" arg  
do
    case $arg in
        k)
        echo "will use port for kcptun: $OPTARG"
        kcpport=$OPTARG
        ;;
        p)
        echo "will use port for ss: $OPTARG"
        serverport=$OPTARG
        ;;
        P)
        echo "will use password: $OPTARG"
        password=$OPTARG
        ;;
        m)
        echo "will use method: $OPTARG"
        method=$OPTARG
        ;;
        h)
        echo "will use ip: $OPTARG"
        serverip=$OPTARG
        ;;
        ?)  #当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
echo ""
if [[ -z $kcpport ]]
then
    echo "use default kcp port: 6666"
    kcpport="6666"
fi

if [[ -z $serverport ]]
then
    echo "use default server port: 8888"
    serverport="8888"
fi

if [[ -z $password ]]
then
    echo "use default password: nathan"
    password="nathan"
fi

if [[ -z $method ]]
then
    echo "use default method: rc4-md5"
    method="rc4-md5"
fi

path="/etc/shadowsocks-libev/"
kcppath="/etc/kcptun/"
file="config.json"
logfile="log"

shadowsockconfigfile=${path}${file}
shadowsocklogfile=${path}${logfile}
kcptunconfigfile=${kcppath}${file}
kcptunlogfile=${kcppath}${logfile}

mkdir -p $path
mkdir -p $kcppath
touch $shadowsockconfigfile
touch $shadowsocklogfile
touch $kcptunconfigfile
touch $kcptunlogfile
chmod -R 666 $path
chmod -R 666 $kcppath
# clear file
cat /dev/null > $shadowsockconfigfile
# # write config
# echo "{" >> $shadowsockconfigfile
# echo "    \"server\": \"$serverip\"," >> $shadowsockconfigfile
# echo "    \"server_port\": \"$serverport\"," >> $shadowsockconfigfile
# echo "    \"password\": \"$password\"," >> $shadowsockconfigfile
# echo "    \"method\": \"$method\"," >> $shadowsockconfigfile
# echo "    \"fast_open\": true" >> $shadowsockconfigfile
# echo "}" >> $shadowsockconfigfile

echo "############################"
echo "## server ip    : $serverip"
echo "## server port  : $serverport"
echo "## password     : $password"
echo "## method       : $method"
echo "## fast open    : true"
echo "############################"

cat > $shadowsockconfigfile <<EOF
{
    "server": "$serverip",
    "server_port": "$serverport",
    "password": "$password",
    "method": "$method",
    "fast_open": true
}
EOF

kcpphonestring="key=$password;crypt=aes;mode=fast2;mtu=1350;sndwnd=1024;rcvwnd=1024;datashard=10;parityshard=3;dscp=0"
cat > $kcptunconfigfile <<EOF
{
    "listen": ":$kcpport",
    "target": "$serverip:$serverport",
    "key": "$password",
    "crypt": "aes",
    "mode": "fast2",
    "mtu": 1350,
    "sndwnd": 1024,
    "rcvwnd": 1024,
    "datashard": 10,
    "parityshard": 3,
    "dscp": 0,
    "nocomp": false,
    "quiet": false,
    "pprof": false
}
EOF

# second install shadowsocks-libev
sudo apt update
sudo apt install shadowsocks-libev -y
sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev -y

# run shadowsocks-libev

cat >> /etc/security/limits.conf << EOF
* soft nofile 51200
* hard nofile 51200
EOF

ulimit -u 65535

cat >> /etc/sysctl.conf << EOF

net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla
EOF

sysctl -p

nohup ss-server -c $shadowsockconfigfile -u -v > $shadowsocklogfile 2>&1 &
# nohup ss-server -c /etc/shadowsocks-libev/config.json -u -v > /etc/shadowsocks-libev/log 2>&1 &

# setup kcptun

wget https://github.com/xtaci/kcptun/releases/download/v20181002/kcptun-linux-amd64-20181002.tar.gz -O kcptun.tar.gz
tar -xvf kcptun.tar.gz
rm -rf client_linux_amd64
nohup ./server_linux_amd64 -c $kcptunconfigfile > $kcptunlogfile 2>&1 &
# nohup ./server_linux_amd64 -c /etc/kcptun/config.json > /dev/null 2>&1 &
echo "kcptun setup done"
echo "####################"
echo "## phone setting:"
echo "##   port    : $kcpport"
echo "##   phoneStr: $kcpphonestring"
echo "####################"

crontab << EOF
* * * * * cat /dev/null > $shadowsocklogfile
* * * * * cat /dev/null > $kcptunlogfile
EOF