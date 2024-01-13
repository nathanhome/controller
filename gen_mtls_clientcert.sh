#!/bin/bash

###########################################################
#
# Generate a client self-signed certifiacte pairs for
# mTLS, validity 365 days. This is a simplification that is
# secure enough for a "household" installation. Professional
# CA for business or large-scale installations is recommended!
#

# set -x

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cert_dir="$SCRIPT_DIR/.selfsigned"
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
                        cert_dir="$1"
                        ;;
        -s | --subject ) shift
                        subject="$1"
                        ;;
        -d | --days ) shift
                        cert_days="$1"
                        ;;
        * )           shift
    esac
    shift
done

cn=$(echo "$subject" | sed -n "s/.*[Cc][Nn]=\(.*\)$/\1/p" )
clientfile=${cert_dir}/${cn}-client-$(date "+%Y%m")


echo "+++ New clientself-signed cert: $subject ($altnames) +++"
# generate a cert request, which gradually produces a server cert
# secp384r1 is at the moment the highest bit level for TLS 1.2/TLS 1.3
openssl ecparam -name secp384r1 -genkey -out ${clientfile}.key
openssl req -new -config $SCRIPT_DIR/selfsignedcerts.cnf \
        -subj "$subject" \
        -key ${clientfile}.key| \
        openssl x509 -req -extfile $SCRIPT_DIR/selfsignedcerts.cnf \
           -signkey ${clientfile}.key \
           -extensions client_auth_cert \
           -days "${cert_days}" \
           -setalias "${cn}-client" -out ${clientfile}.pem
openssl x509 -outform der -in ${clientfile}.pem  -out ${clientfile}.der                 
chown $user:$group ${clientfile}.key ${clientfile}.pem ${clientfile}.der 
chmod 640 ${clientfile}.key
chmod 644 ${clientfile}.pem ${clientfile}.der 

# you can check cert with
# openssl x509 -text -in <certfile>.pem
