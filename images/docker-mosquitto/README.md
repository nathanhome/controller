## Mosquitto

#### Creating users with password
'''
'''

#### Prerequisite: generate passwd file using eclipse-mosquitto plain base container
Generate user/password
```
> docker run -p 1883:1883 -p 9001:9001 -v $HOME/.nathan/mosquitto/data:/mosquitto/data -v $HOME/.nathan/mosquitto/logs:/mosquitto/logs eclipse-mosquitto:1.6
> docker exec -it <running container id> /usr/bin/mosquitto_passwd -c /mosquitto/data/mosquitto.passwd <myfirstuser>
```
Take care that you do not rebuild the passwd file afterwards and only use:
```
> docker exec -it <running container id> /usr/bin/mosquitto_passwd /mosquitto/data/mosquitto.passwd <myseconduser>
```


#### Building Mosquitto image
```
> docker build --pull --rm -t nathanhome/mosquitto:0.1.0 .
```

#### Running Mosquitto images
```
> docker run -d -p 1883:1883 -p 9001:9001 -v $HOME/.nathan/mosquitto:/mosquitto/data -v $HOME/.nathan/logs:/mosquitto/log  --network home-net --network-alias mqtts.home nathanhome/mosquitto:0.1.0
```


#### Test MQTT setup from commandline with Docker
```
docker exec -it <running container id> /usr/bin/mosquitto_sub -t test -h localhost < -u user> < -P password> -m "Message"  --cafile
```

```
docker exec -it 8980b904b922 /usr/bin/mosquitto_pub -t test -h mosquitto --cafile /mosquitto/data/nathan-mqtts.rederlechner.home-chain.pem -u homeassi -P "-2R3d-4_H0me#Ctrl_19761" -m "Hello"
```
