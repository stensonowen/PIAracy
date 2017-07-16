#!/bin/sh
# for fedora
# remember to put your "USERNAME\nPASSWORD" in the file ".creds"


# vars
DIR=/tmp/pia        # temporary/backup place for config files
CREDS_FN=".creds"   # filename where pia credentials will be stored in plaintext
PIA_USER=`cat .creds | head -n 1`
PIA_PASS=`cat .creds | head -n 2 | tail -n 1`


echo Installing dependencies 
dnf update -q
dnf install openvpn unzip wget -qy
#dnf install vim tmux git htop -qy


# get config files
echo Setting up config files at $DIR
mkdir $DIR
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip -O $DIR/openvpn.zip --quiet
unzip -q $DIR/openvpn.zip -d $DIR 


# set up creds file
echo -e "$PIA_USER\n$PIA_PASS\n" > /etc/openvpn/$CREDS_FN
chmod 0600 /etc/openvpn/$CREDS_FN


# set up config files

# point config files to credential file so we aren't prompted at every connect
echo "auth-user-pass $CREDS_FN" | tee -a $DIR/*.ovpn > /dev/null
# spaces will fuck with systemd (fedora's `rename` straight up can't do this)
# can usually just `rename 's/ /_/g' $DIR/*`
for CFG in $DIR/*' '*.ovpn; do mv "$CFG" `echo $CFG | tr ' ' '_'`; done 
# systemd requires specific file suffix
rename .ovpn .conf $DIR/*.ovpn
cp $DIR/* /etc/openvpn/

echo Done


# Usage:
#   `systemctl start|status|stop openvpn@US_East.service`

