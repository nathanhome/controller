#!/bin/bash

###########################################################
#
# Generate a server self-signed certificate pairs for
# mTLS, validity 365 days. This is a simplification that is
# secure enough for a "household" installation. Professional
# CA for business or large-scale installations is recommended!
#

# set -x

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cert_dir="$SCRIPT_DIR/.privateserverca"
subject="/C=XX/ST=MyState/L=MyTown/O=Home/OU=Housename/CN=your server primary name" 
cert_days=365
user=$(whoami)
group=$(whoami)

while (( "$#" )); do
    case $1 in
        -u | --user ) shift
                        user="$1"
                        ;;
        -g | --group ) shift
                        group="$1"
                        ;;
        -p | --path ) shift
                        ca_dir="$1"
                        ;;
        -s | --subject ) shift
                        subject="$1"
                        ;;
        -a | --alt ) shift
                        altnames="$1"
                        ;;
        -d | --days ) shift
                        cert_days="$1"
                        ;;
        * )           shift
    esac
    shift
done

cn=$(echo "$subject" | sed -n "s/.*[Cc][Nn]=\(.*\)$/\1/p" )
servercafile=${ca_dir}/${cn}ca-$(date "+%Y%m")
casubject="${subject} webserver root" 

echo "+++ New server ca cert: $subject webserver root +++"
# generate a cert request, which gradually produces a server cert
# secp384r1 is at the moment the highest bit level for TLS 1.2/TLS 1.3
openssl ecparam -name secp384r1 -genkey -out ${servercafile}.key
openssl req -new -config $SCRIPT_DIR/selfsignedcerts.cnf \
        -subj "$casubject" \
        -key ${servercafile}.key| \
        openssl x509 -req -CAcreateserial \
           -extfile $SCRIPT_DIR/selfsignedcerts.cnf \
           -CAserial ${servercafile}.srl \
           -signkey ${servercafile}.key \
           -extensions server_ca \
           -days "${cert_days}" \
           -setalias "${cn}ca" -out ${servercafile}.pem 
openssl x509 -outform der -in ${servercafile}.pem  -out ${servercafile}.cer
chgrp $group ${servercafile}.key ${servercafile}.pem ${servercafile}.cer 
chmod 600 ${servercafile}.key
chmod 644 ${servercafile}.pem ${servercafile}.cer 

# you can check cert with
# openssl x509 -text -in <certfile>.pem
