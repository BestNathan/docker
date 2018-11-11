## install

```shell
sudo apt update
sudo apt install shadowsocks-libev

# Installation of basic build dependencies
## Debian / Ubuntu
sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev
## CentOS / Fedora / RHEL
sudo yum install gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel
## Arch
sudo pacman -S gettext gcc autoconf libtool automake make asciidoc xmlto c-ares libev
```

## bbr

```shell
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh && chmod +x bbr.sh && bash bbr.sh
```