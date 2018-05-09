#!/bin/bash -x
echo "*** Installing SaltStack ***"
yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm 
yum clean expire-cache
yum install salt-minion

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