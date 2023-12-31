#!/bin/bash

NATHAN_MQTT_VERSION=2.0-2 \
NATHAN_MARIADB_VERSION=11.2 \
NATHAN_HASS_VERSION=2023.12-1 \
NATHAN_ZWAVEJS_VERSION=9.6-1 \
NATHAN_VERSION=23.0.2 \
NATHAN_GROUP=$(getent group homeauto  | cut -d: -f3) \
DIALOUT_GROUP=$(getent group dialout | cut -d: -f3) \
docker-compose $@