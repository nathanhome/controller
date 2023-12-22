#!/bin/bash

# MQTT Mosquitto user
adduser --system --uid 1883 --group --disabled-login --shell /sbin/nologin mosquitto
usermod --comment "NATHAN mosquitto user" mosquitto
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/config
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/log
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/data

# create mosquitto passwd file
docker run -ti -u 1883 -v /home/mosquitto/.nathan/.sec:/mosquitto/.sec \
  eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/.sec/mosquitto.passwd homeassist
sudo -u mosquitto docker rm <hash>

# Homesistant user
adduser --system --uid 1884 --group --disabled-login --shell /sbin/nologin assistant
usermod --comment "NATHAN home assistant user" assistant

# Homesistant user
adduser --system --uid 1885 --group --disabled-login --shell /sbin/nologin zwaver
usermod --comment "NATHAN zwave2mqtt user" zwaver
