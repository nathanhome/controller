#!/bin/sh

function set_value {
    jsonFile=$1
    field=$2
    value=$3

    # just replace unique json field
    sed -i "s|\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"|\"$field\": \"$value\"|g" "$jsonFile"
}

function set_number_value {
    jsonFile=$1
    field=$2
    value=$3

    # just replace unique json field
    sed -i "s|\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"|\"$field\": $value|g" "$jsonFile"
}

function set_run_secret {
    jsonFile=$1
    field=$2
    secret=$3

    # Read PEM file, replace line breaks with \n, and escape backslashes and double quotes for shell var
    secretContent=$(sed ':a;N;$!ba;s/\n/\\n/g' "$secret" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    sed -i "s|\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"|\"$field\": \"$secretContent\"|g" "$jsonFile"
}

# Read each line from the file and export it as an environment variable
# see https://raw.githubusercontent.com/zwave-js/zwave-js-ui/master/docs/guide/env-vars.md
# for available variables
while IFS= read -r line; do
  export $line
done < /run/secrets/zwgate_secrets

# this is a setting workaround until there is a better way
if [ ! -f /usr/src/app/store/settings.json ]; then
  echo {"mqtt":{"host": "","port": 8883,"_ca": "","ca": "","_cert": "","cert": "","_key": "","key": ""} \
       > /usr/src/app/store/settings.json
fi

set_run_secret /usr/src/app/store/settings.json _ca /run/secrets/zwgate_mqtt_ca
set_value /usr/src/app/store/settings.json ca "_on_boot_trust_"
set_run_secret /usr/src/app/store/settings.json _cert /run/secrets/zwgate_mqtt_cert
set_value /usr/src/app/store/settings.json cert "_on_boot_cert_"
set_run_secret /usr/src/app/store/settings.json _key /run/secrets/zwgate_mqtt_key
set_value /usr/src/app/store/settings.json key "_on_boot_key_"
set_value /usr/src/app/store/settings.json  host "$MQTT_HOST"
#set_number_value /usr/src/app/store/settings.json mqtt port "$MQTT_PORT"

# execute CMD from base image
exec $@