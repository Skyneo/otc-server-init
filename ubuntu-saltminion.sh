#!/bin/bash -x
echo "*** Installing SaltStack ***"
wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
add-apt-repository "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/2017.7 xenial main"
apt-get update
apt-get -y install salt-minion

if [ -z "$2" ]; then
env="base"
else
env=$2
fi

set -x
sed -i -e "/hash_type:/c\hash_type: sha256" /etc/salt/minion
echo "id: `hostname`" > /etc/salt/minion.d/minion.conf
echo "master: $1" >> /etc/salt/minion.d/minion.conf
echo "master_port: 4506" >> /etc/salt/minion.d/minion.conf
echo "publish_port: 4505" >> /etc/salt/minion.d/minion.conf
echo "saltenv: $env" >> /etc/salt/minion.d/minion.conf
echo "environment: $env" >> /etc/salt/minion.d/minion.conf
echo "state_top_saltenv: $env" >> /etc/salt/minion.d/minion.conf
echo "default_top: $env" >> /etc/salt/minion.d/minion.conf
echo "test: false" >> /etc/salt/minion.d/minion.conf
echo "master_type: str" >> /etc/salt/minion.d/minion.conf
set +x

systemctl enable salt-minion
systemctl restart salt-minion
