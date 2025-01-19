#!/bin/bash

# step 1: Generate private website certificate with server ca
# This is required to trust the website, esp. on android
# TODO: see github.io/... for details
mkdir -p /home/digital/.nathan
./gen_private_serverca.sh -u digital -g digital --path /home/digital/.nathan \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=nathan" \
    --days 400

mkdir -p /home/digital/.nathan/common
./gen_private_servercert.sh -u digital -g homeauto --path /home/digital/.nathan/common \
    --capath /home/digital/.nathan \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=nathan" \
    --alt "DNS:nathan,DNS:nathan.fritz.box,DNS:nathan.rederlechner.home"
cp /home/digital/.nathan/common/nathan-$(date "+%Y%m").der /home/digital/.nathan/common/nathan-$(date "+%Y%m").cer

# fully kiosk https
mkdir -p /home/digital/.nathan/home-tablet1
./gen_private_servercert.sh -u digital -g digital --path /home/digital/.nathan/home-tablet1 \
    --capath /home/digital/.nathan \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=home-tablet1" \
    --alt "DNS:home-tablet1,DNS:home-tablet1.fritz.box,DNS:home-tablet1.rederlechner.home"
openssl pkcs12 -legacy -export \
    -out /home/digital/.nathan/home-tablet1/fully-remote-admin-ca.p12 \
    -inkey /home/digital/.nathan/home-tablet1/home-tablet1-$(date "+%Y%m").key \
    -in /home/digital/.nathan/home-tablet1/home-tablet1-$(date "+%Y%m").pem \
    -passout pass:fully

# step 2: generate mtls server certificates
# python is special in the sense that it expects a duplicate of CN in SAN
# so we do preemptively
#
# to avoid complicated DNS entries (not supported by FritzBox),
# The certificate is also for access directly via nathan.fritz.box,
# but only delievered on mqtts port 8883
mkdir -p /home/digital/.nathan/mosquitto
./gen_mtls_servercert.sh -u digital -g mosquitto --path /home/digital/.nathan/mosquitto \
    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=mqbroker" \
    --alt "DNS:mqbroker,DNS:mqbroker.fritz.box,DNS:mqbroker.rederlechner.home,DNS:nathan,DNS:nathan.fritz.box,DNS:nathan.rederlechner.home"

#step 3 give all parts acting as client for some other service a client cert
mkdir -p /home/digital/.nathan/homeassistant
./gen_mtls_clientcert.sh -u digital -g assistant --path /home/digital/.nathan/homeassistant \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=homeassistant" 
mkdir -p /home/digital/.nathan/zwgate
./gen_mtls_clientcert.sh -u digital -g zwgate --path /home/digital/.nathan/zwgate \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zwgate" 
mkdir -p /home/digital/.nathan/zigate
./gen_mtls_clientcert.sh -u digital -g zigate --path /home/digital/.nathan/zigate \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zigate" 

# (optionl) mTLS for BBiQ MQTT barbecue sensor based upon ESP32
# remember to recompile BBiQ firmware after refresh with new certificate (preliminary)
mkdir -p /home/digital/.nathan/bbiq
./gen_mtls_clientcert.sh -u digital -g digital --path /home/digital/.nathan/bbiq \
   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=bbiq" 

#step 4: collect trustfiles that only contain the relevant client certs
./gen_mtls_trust.sh -u digital -g mosquitto -f /home/digital/.nathan/mosquitto/mqbroker-trust \
    /home/digital/.nathan/homeassistant/homeassistant-client \
    /home/digital/.nathan/zwgate/zwgate-client \
    /home/digital/.nathan/zigate/zigate-client \
    /home/digital/.nathan/bbiq/bbiq-client
./gen_mtls_trust.sh -u digital -g assistant -f /home/digital/.nathan/homeassistant/homeassistant-trust \
    /home/digital/.nathan/mosquitto/mqbroker \
    /home/digital/.nathan/homeassistant/homeassistant-client \
    /home/digital/.nathan/nathanca
./gen_mtls_trust.sh -u digital -g zwgate -f /home/digital/.nathan/zwgate/zwgate-trust \
    /home/digital/.nathan/mosquitto/mqbroker
./gen_mtls_trust.sh -u digital -g zigate -f /home/digital/.nathan/zigate/zigate-trust \
    /home/digital/.nathan/mosquitto/mqbroker \
    /home/digital/.nathan/zigate/zigate-client

# (optional) mTLS for Silvercrest/Lidl/Tuya zigbee gateway
# this is not effectively used yet, as socat is not a stable solution
# we need to extend the gateway code with circuit breaker behavior and client cert support <TODO>y
#
#mkdir -p /home/digital/.nathan/zigatekeeper
#./gen_mtls_servercert.sh -u digital -g zigate --path /home/digital/.nathan/zigatekeeper \
#    --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zigatekeeper" \
#    --alt "DNS:zigatekeeper,DNS:zigatekeeper.fritz.box;DNS:zigatekeeper.rederlechner.home"
# zigate already has a client certificate for mqtt, though...
#./gen_mtls_clientcert.sh -u digital -g zigate --path /home/digital/.nathan/zigate \
#   --subject "/C=DE/ST=Saarland/L=Sankt Wendel/O=Home/OU=Rederlechner/CN=zigate2keeper" 
#cat /home/digital/.nathan/zigatekeeper/zigatekeeper-client-$(date "+%Y%m").key \
#   /home/digital/.nathan/zigatekeeper/zigatekeeper-client-$(date "+%Y%m").pem \
#   > /home/digital/.nathan/zigatekeeper/zigatekeeper-socat-client-$(date "+%Y%m").pem

#TODO: generate certs for DB
#TODO: generate certs for zigbee mTLS serial gateway




