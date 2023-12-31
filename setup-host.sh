#!/bin/bash

addgroup --gid 1882 homeauto

# MQTT Mosquitto user
adduser --system --uid 1883 --group --disabled-login --shell /sbin/nologin mosquitto
usermod --comment "NATHAN mosquitto user" mosquitto
mkdir -p /home/mosquitto/.nathan/config
mkdir -p /home/mosquitto/.nathan/data
usermod -a -G homeauto mosquitto
## create mosquitto passwd file
docker run -ti -u 1883 -v /home/mosquitto/.nathan/.sec:/mosquitto/.sec \
  eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/.sec/mosquitto.passwd assistant
# sudo -u mosquitto docker rm <hash>
## logs
mkdir -p /var/log/mqbroker
chown mosquitto:mosquitto /var/log/mqbroker
chmod 750 /var/log/mqbroker

# Homeassistant user
adduser --system --uid 1884 --group --disabled-login --shell /sbin/nologin assistant
usermod --comment "NATHAN home assistant user" assistant
usermod -a -G homeauto assistant
## logs
mkdir -p /var/log/homeassistant
chown assistant:homeauto /var/log/homeassistant
chmod 750 /var/log/homeassistant

# Zwave gateway user
adduser --system --uid 1885 --group --disabled-login --shell /sbin/nologin zwgate
usermod --comment "NATHAN zwavejs2mqtt user" zwgate
mkdir -p /home/zwgate/.nathan/data
mkdir -p /mnt/nathan/zwgate/backup
usermod -a -G homeauto,dialout zwgate
## logs
mkdir -p /var/log/zwgate
chown zwgate:homeauto /var/log/zwgate
chmod 750 /var/log/zwgate


# Zigbee gateway user
adduser --system --uid 1886 --group --disabled-login --shell /sbin/nologin zigate
usermod --comment "NATHAN zigbee2mqtt user" zigate
mkdir -p /home/zigate/.nathan/data
chown zigate:digital /home/zigate/.nathan
chmod 770 /home/zigate/.nathan
chown zigate:digital /home/zigate/.nathan/data
usermod -a -G homeauto,dialout zigate
## logs
mkdir -p /var/log/zigate
chown zigate:homeauto /var/log/zigate
chmod 750 /var/log/zigate


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

