# 一键部署脚本

## 部署shadowsock

参考网站[click](https://teddysun.com/342.html)

### install

```shell
    wget --no-check-certificate -O shadowsocks-go.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-go.sh
    chmod +x shadowsocks-go.sh
    ./shadowsocks-go.sh 2>&1 | tee shadowsocks-go.log
```

### uninstall

```shell
    ./shadowsocks-go.sh uninstall
```

### config

配置文件路径：/etc/shadowsocks.json

#### single user

```json
{
    "server":"0.0.0.0",
    "server_port": "port",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"your_password",
    "timeout":300,
    "method":"your_encryption_method",
    "fast_open": false
}
```

#### multi-user

```json
{
    "server":"0.0.0.0",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password":{
        "8989":"password0",
        "9001":"password1",
        "9002":"password2",
        "9003":"password3",
        "9004":"password4"
    },
    "timeout":300,
    "method":"your_encryption_method",
    "fast_open": false
}
```

### command

- 启动：/etc/init.d/shadowsocks start
- 停止：/etc/init.d/shadowsocks stop
- 重启：/etc/init.d/shadowsocks restart
- 状态：/etc/init.d/shadowsocks status

## speed up

### limit

- vi /etc/security/limits.conf
- add conf
```shell
* soft nofile 51200
* hard nofile 51200
```
- ulimit -n 51200

### sysctl.conf

- sudo vi /etc/sysctl.conf
- add conf

```shell
fs.file-max = 51200

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
```

- sysctl -p

## kcptun

### install

```shell
wget --no-check-certificate https://github.com/kuoruan/shell-scripts/raw/master/kcptun/kcptun.sh
chmod +x ./kcptun.sh
./kcptun.sh
```

## ez_install

```shell
//wget
wget http://peak.telecommunity.com/dist/ez_setup.py
// install
python ez_setup.py
// update
python ez_setup.py –U setuptools
```
