#!/bin/sh

sudo apt-get update
#sudo apt-get upgrade -y
sudo apt-get install openvpn unzip wget curl -y
sudo apt-get install python3-libtorrent
sudo apt-get install python3-pip python-dbus
#sudo apt-get install vim tmux git htop -y

# todo: rename all scripts from *.ovpn to *.conf in /etc/openvpn
# todo: set scripts to auto-restart (?)

DIR=/home/vagrant/pia
mkdir $DIR
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip -O $DIR/openvpn.zip
unzip $DIR/openvpn.zip -d $DIR



