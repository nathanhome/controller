#!/bin/bash

addgroup --gid 1882 homeauto

sudo -u digital mkdir --mode 770 -p /home/digital/.nathan/logs
sudo -u digital chown digital:homeauto /home/digital/.nathan/logs

# MQTT Mosquitto user
adduser --system --uid 1883 --group --disabled-login --shell /sbin/nologin mosquitto
usermod --comment "NATHAN mosquitto user" mosquitto
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/config
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/log
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/data
usermod -a -G homeauto mosquitto

# create mosquitto passwd file
docker run -ti -u 1883 -v /home/mosquitto/.nathan/.sec:/mosquitto/.sec \
  eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/.sec/mosquitto.passwd assistant
sudo -u mosquitto docker rm <hash>

# Homeassistant user
adduser --system --uid 1884 --group --disabled-login --shell /sbin/nologin assistant
usermod --comment "NATHAN home assistant user" assistant
usermod -a -G homeauto assistant

# Zwave gateway user
adduser --system --uid 1885 --group --disabled-login --shell /sbin/nologin zwgate
usermod --comment "NATHAN zwavejs2mqtt user" zwgate
sudo -u zwgate mkdir -p /home/zwgate/.nathan/data
sudo -u zwgate mkdir -p /mnt/nathan/zwgate/backup
usermod -a -G homeauto,dialout zwgate

# Zigbee gateway user
adduser --system --uid 1886 --group --disabled-login --shell /sbin/nologin zigate
usermod --comment "NATHAN zigbee2mqtt user" zigate
sudo -u zigate mkdir -p /home/zigate/.nathan/data
#sudo -u zigate mkdir -p /mnt/nathan/zwgate/backup
usermod -a -G homeauto


