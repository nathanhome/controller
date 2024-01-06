#!/bin/bash

# step 1: give all servers with web access a certificate
./gen_mtls_servercert.sh -u digital -g homeauto --path /home/digital/.nathan/common \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=nathan" \
    --alt "DNS:nathan.fritz.box;DNS:nathan.rederlechner.home"
./gen_mtls_servercert.sh -u digital -g mosquitto --path /home/digital/.nathan/mosquitto \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=mqbroker" \
    --alt "DNS:mqbroker.fritz.box;DNS:mqbroker.rederlechner.home"

#step 2 give all parts acting as client for some other service a client cert
./gen_mtls_clientcert.sh -u digital -g assistant --path /home/digital/.nathan/homeassistant \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=homeassistant" 
./gen_mtls_clientcert.sh -u digital -g zwgate --path /home/digital/.nathan/zwgate \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zwgate" 
#./gen_mtls_clientcert.sh -u digital -h assistant -d /home/digital/.nathan/homeassistant \
#   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=homeassistant" 

#step 3: collect trustfiles that only contain the relevant client certs
./gen_mtls_trust.sh -u digital -g mosquitto -f /home/digital/.nathan/mosquitto/mqbroker-trust \
    /home/digital/.nathan/homeassistant/homeassistant-client \
    /home/digital/.nathan/zwgate/zwgate-client # \
    # /home/digital/.test/homeassistant/zigate.pem
./gen_mtls_trust.sh -u digital -g assistant -f /home/digital/.nathan/homeassistant/homeassistant-trust \
    /home/digital/.nathan/mosquitto/mqbroker
./gen_mtls_trust.sh -u digital -g zwgate -f /home/digital/.nathan/zwgate/zwgate-trust \
    /home/digital/.nathan/mosquitto/mqbroker


#TODO: generate certs for DB
#TODO: generate certs for zigbee mTLS serial gateway




