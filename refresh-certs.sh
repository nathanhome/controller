#!/bin/bash

# step 1: Generate private website certificate with server ca
# This is required to trust the website, esp. on android
# TODO: see github.io/... for details
./gen_private_serverca.sh -u digital -g digital --path /home/digital/.nathan \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=nathan" \
    --days 400

./gen_private_servercert.sh -u digital -g homeauto --path /home/digital/.nathan/common \
    --capath /home/digital/.nathan \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=nathan" \
    --alt "DNS:nathan,DNS:nathan.fritz.box;DNS:nathan.rederlechner.home"

# step 2: generate mtls server certificates
# python is special in the sense that it expects a duplicate of CN in SAN
# so we do preemptively
cp /home/digital/.nathan/common/nathan-$(date "+%Y%m").der /home/digital/.nathan/nathan-$(date "+%Y%m").cer
./gen_mtls_servercert.sh -u digital -g mosquitto --path /home/digital/.nathan/mosquitto \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=mqbroker" \
    --alt "DNS:mqbroker,DNS:mqbroker.fritz.box;DNS:mqbroker.rederlechner.home"

#step 3 give all parts acting as client for some other service a client cert
./gen_mtls_clientcert.sh -u digital -g assistant --path /home/digital/.nathan/homeassistant \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=homeassistant" 
./gen_mtls_clientcert.sh -u digital -g zwgate --path /home/digital/.nathan/zwgate \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zwgate" 
./gen_mtls_clientcert.sh -u digital -g zigate --path /home/digital/.nathan/zigate \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zigate" 

#step 4: collect trustfiles that only contain the relevant client certs
./gen_mtls_trust.sh -u digital -g mosquitto -f /home/digital/.nathan/mosquitto/mqbroker-trust \
    /home/digital/.nathan/homeassistant/homeassistant-client \
    /home/digital/.nathan/zwgate/zwgate-client \
    /home/digital/.nathan/zigate/zigate-client
./gen_mtls_trust.sh -u digital -g assistant -f /home/digital/.nathan/homeassistant/homeassistant-trust \
    /home/digital/.nathan/mosquitto/mqbroker \
    /home/digital/.nathan/homeassistant/homeassistant-client 
./gen_mtls_trust.sh -u digital -g zwgate -f /home/digital/.nathan/zwgate/zwgate-trust \
    /home/digital/.nathan/mosquitto/mqbroker
./gen_mtls_trust.sh -u digital -g zigate -f /home/digital/.nathan/zigate/zigate-trust \
    /home/digital/.nathan/mosquitto/mqbroker \
    /home/digital/.nathan/zigate/zigate-client

#TODO: generate certs for DB
#TODO: generate certs for zigbee mTLS serial gateway




