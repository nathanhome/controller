#!/bin/bash

# MQTT Mosquitto user
adduser --system --uid 1883 --group --disabled-login --shell /sbin/nologin mosquitto
usermod mosquitto --comment "NATHAN mosquitto user" mosquitto
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/.sec
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/config
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/log
sudo -u mosquitto mkdir -p /home/mosquitto/.nathan/data

# create mosquitto passwd file
docker run -ti -u 1883 -v /home/mosquitto/.nathan/.sec:/mosquitto/.sec \
  eclipse-mosquitto:latest mosquitto_passwd -c /mosquitto/.sec/mosquitto.passwd homeassist
sudo -u mosquitto docker rm <hash>