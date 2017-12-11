#!/bin/sh

# remember to put your "USERNAME\nPASSWORD" in the file ".creds"


# vars
DIR=/tmp/pia        # temporary/backup place for config files
CREDS_PATH=".creds" # filename where pia credentials will be stored in plaintext
PIA_CREDS=`cat /vagrant/.creds`


echo Installing dependencies 
aptitude update -q=3
aptitude install openvpn unzip wget -q=3 -y
aptitude install vim tmux git htop -q=3 -y


# get config files
echo Setting up config files at $DIR
mkdir $DIR
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip -O $DIR/openvpn.zip --quiet
unzip -q $DIR/openvpn.zip -d $DIR 


# set up creds file
echo "$PIA_CREDS" > /etc/openvpn/$CREDS_PATH    # don't omit quotes
chmod 0600 /etc/openvpn/$CREDS_PATH


# point config files to credential file so we aren't prompted at every connect
echo "auth-user-pass $CREDS_PATH" | tee -a $DIR/*.ovpn > /dev/null
# spaces will fuck with systemd (and it requires a specific suffix)
rename 's/ /_/g' $DIR/*
rename 's/\.ovpn$/\.conf/' $DIR/*.ovpn
cp $DIR/* /etc/openvpn/


echo Installing other things
aptitude install transmission-daemon transmission-remote-cli -q=3 -y


echo Cleaning up
rm -rf /tmp/pia


# Usage:
#   `systemctl start|status|stop openvpn@US_East.service`

# TODO
#   fix settings? unset `rpc-authentication-required` in /etc/transmission-daemon/settings.json
#   fix aptitude verbosity

