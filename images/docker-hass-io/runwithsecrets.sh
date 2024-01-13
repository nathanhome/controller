#!/bin/sh

###
# add secrets.yaml from run secrets as link
ln -s /run/secrets/hass_secrets /config/secrets.yaml

###
# The mqtt settings have to be injected to the (new)
# Homeassistant ConfigEntry mechanism (I dislike)
jq --arg trust "$(cat /run/secrets/hass_mqtt_trust)" \
   --arg key "$(cat /run/secrets/hass_mqtt_key)" \
   --arg cert "$(cat /run/secrets/hass_mqtt_cert)" \
   --arg host "$HASS_MQTT_HOST" \
   --arg port "$HASS_MQTT_PORT" \
  '.data.entries |= map(
      if .domain == "mqtt" and .title == "mqbroker" then 
        .data.broker = $host |
        .data.port = ($port|tonumber) |
        .data.certificate = $trust |
        .data.client_key = $key |
        .data.client_cert = $cert |
        .data.tls_insecure = false |
        .data.protocol = "5" |
        del(.data.username) |
        del(.data.password)
      else . end)' /config/.storage/core.config_entries > /tmp/core.config_entries &&
mv -f /tmp/core.config_entries /config/.storage/core.config_entries

# call the original entrypoint (since S6_overly is used)
exec /init