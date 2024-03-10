#!/bin/bash

# common secrets for the whole homeauto cluster
addgroup --gid 1882 homeauto
usermod -a -G homeauto digital
mkdir -p /home/digital/.nathan/common
chown digital:homeauto /home/digital/.nathan/common
chmod 770 /home/digital/.nathan/common

# MQTT Mosquitto user
adduser --system --uid 1883 --group --disabled-login --shell /sbin/nologin mosquitto
usermod -a -G homeauto --comment "NATHAN mosquitto user" mosquitto
usermod -a -G mosquitto digital

mkdir -p /home/mosquitto/.nathan/config
mkdir -p /home/mosquitto/.nathan/data

## create mosquitto passwd file; if in use
#docker run -ti -u 1883 -v /home/mosquitto/.nathan/.sec:/mosquitto/.sec \
#  eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/.sec/mosquitto.passwd assistant
# sudo -u mosquitto docker rm <hash>

## logs
mkdir -p /var/log/mqbroker
chown mosquitto:mosquitto /var/log/mqbroker
chmod 750 /var/log/mqbroker

# Homeassistant user
adduser --system --uid 1884 --group --disabled-login --shell /sbin/nologin assistant
usermod -a -G homeauto --comment "NATHAN home assistant user" assistant
usermod -a -G assistant digital

## logs
mkdir -p /var/log/homeassistant
chown assistant:homeauto /var/log/homeassistant
chmod 750 /var/log/homeassistant

# Zwave gateway user
adduser --system --uid 1885 --group --disabled-login --shell /sbin/nologin zwgate
usermod -a -G homeauto,dialout --comment "NATHAN zwavejs2mqtt user" zwgate
usermod -a -G zwgate digital

mkdir -p /home/zwgate/.nathan/data
mkdir -p /mnt/nathan/zwgate/backup
usermod -a -G homeauto,dialout zwgate
## logs
mkdir -p /var/log/zwgate
chown zwgate:homeauto /var/log/zwgate
chmod 750 /var/log/zwgate

# Zigbee gateway user
adduser --system --uid 1886 --group --disabled-login --shell /sbin/nologin zigate
usermod -a -G homeauto,dialout --comment "NATHAN zigbee2mqtt user" zigate
usermod -a -G zigate digital

mkdir -p /home/zigate/.nathan/data
chown zigate:digital /home/zigate/.nathan
chmod 770 /home/zigate/.nathan
chown zigate:digital /home/zigate/.nathan/data
usermod -a -G homeauto,tty zigate
cp image/docker-zigate/configuration.yaml /home/zigate/.nathan/data
ln -s /run/secrets/zigate_secrets ~zigate/.nathan/data/secret.yaml

# Zigatekeeper: hold also certificates/keys for Lidl ZIgbee gateway (mTLS)
mkdir -p /home/zigate/.nathan/data


# homedb MariaDB user
adduser --system --uid 1887 --group --disabled-login --shell /sbin/nologin homedb
usermod --comment "NATHAN MariaDB user" homedb
mkdir -p /home/homedb/.nathan/data
chown homedb:digital /home/homedb/.nathan
chmod 770 /home/homedb/.nathan
chown homedb:digital /home/homedb/.nathan/data
chmod 770 /home/homedb/.nathan/data
usermod -a -G homeauto homedb
## logs
mkdir -p /var/log/homedb
chown homedb:homeauto /var/log/homedb
chmod 750 /var/log/homedb

# add solarspot user
adduser --system --uid 1888 --group --disabled-login --shell /sbin/nologin solar
usermod --comment "NATHAN solar spotter" solar
usermod -a -G homeauto,bluetooth solar


