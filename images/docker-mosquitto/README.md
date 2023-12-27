## Mosquitto

#### Prerequisite: generate passwd file using eclipse-mosquitto plain base container
Create initial passwd file
```
> docker run -p 1983:1883 -p 9901:9001 -v $HOME/.nathan/mosquitto/mosquitto.passwd:/mosquitto/config/mosquitto.passwd eclipse-mosquitto:2.0-openssl /usr/bin/mosquitto_passwd -b /mosquitto/config/mosquitto.passwd -c <first user> "passwd"
```

Update user passwd
```
> docker run -p 1983:1883 -p 9901:9001 -v $HOME/.nathan/mosquitto/mosquitto.passwd:/mosquitto/config/mosquitto.passwd eclipse-mosquitto:2.0-openssl /usr/bin/mosquitto_passwd -b /mosquitto/config/mosquitto.passwd <mqtts_user, e.g. homeassistant> "passwd"
```

Delete user:
```
docker run -p 1983:1883 -p 9901:9001 -v $HOME/.nathan/mosquitto/mosquitto.passwd:/mosquitto/config/mosquitto.passwd eclipse-mosquitto:2.0-openssl /usr/bin/mosquitto_passwd -D /mosquitto/config/mosquitto.passwd <user>
```

#### Building Mosquitto image
```
NATHAN_MQTT_VERSION=2.0-1 NATHAN_HASS_VERSION=2023.7 NATHAN_VERSION=23.0.1 docker-compose build mqbroker
```

#### Running Mosquitto image (only)
```
NATHAN_MQTT_VERSION=2.0-1 NATHAN_HASS_VERSION=2023.7 NATHAN_VERSION=23.0.1 docker-compose up -d mqbroker
```


#### Test MQTT setup from commandline with Docker

Listen to a test queue:
```
docker exec -it controller_mqbroker_1 /usr/bin/mosquitto_sub -t test -h mqbroker --cafile /mosquitto/config/nathan-mqbroker.nathan.home-chain.pem -u homeassist -P "<pass>"
```

Publish to test queue:
```
docker exec -it controller_mqbroker_1 /usr/bin/mosquitto_pub -t test -h mqbroker --cafile /mosquitto/config/nathan-mqbroker.nathan.home-chain.pem -u homeassist -P "<pass>" -m "Hello"
```
