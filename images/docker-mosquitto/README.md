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
The secure home automation setup requires 

```
./compose.sh build mqbroker
```

#### Running Mosquitto image (only)
```
./compose.sh build mqbroker
```


#### Test MQTT setup from commandline with Docker

Listen to a test queue:
```
docker exec -it controller_mqbroker_1 /usr/bin/mosquitto_sub -t test -h mqbroker \
  --cafile /run/secrets/mqbroker_ca  -u zwaver -P "<pass>"
```

Publish to test queue:
```
docker exec -it controller_mqbroker_1 /usr/bin/mosquitto_pub -t test -h mqbroker \
  --cafile /run/secrets/mqbroker_ca  -u zwaver -m "Hello" -P "<pass>" 
```

#### Test outside connection
```
mosquitto_pub --cafile clients/certs/ca.pem --cert clients/certs/client.pem --key clients/certs/client.key -t "homeassistant/sensor/<existing_sensor>/availability" -m "online" -h nathan -p 8883 -d
```