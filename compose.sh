#!/bin/bash

NATHAN_MQTT_VERSION=2.0-2 \
NATHAN_MARIADB_VERSION=11.2 \
NATHAN_HASS_VERSION=2024.5-1 \
NATHAN_ZWAVEJS_VERSION=9.6-2 \
NATHAN_ZIGBEE2MQTT_VERSION=1.35.1 \
NATHAN_SBFSPOT_VERSION=3.9.7-1 \
NATHAN_VERSION=24.0.1 \
NATHAN_GROUP=$(getent group homeauto  | cut -d: -f3) \
DIALOUT_GROUP=$(getent group dialout | cut -d: -f3) \
TTY_GROUP=$(getent group tty | cut -d: -f3) \
BLUETOOTH_GROUP=$(getent group bluetooth | cut -d: -f3) \
docker-compose $@