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

cert_dir="$SCRIPT_DIR/.privateserver"
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
        -c | --capath ) shift
                        ca_dir="$1"
                        ;;
        -p | --path ) shift
                        cert_dir="$1"
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
serverfile=${cert_dir}/${cn}-$(date "+%Y%m")
servercafile=${ca_dir}/${cn}ca-$(date "+%Y%m")

if [ -z ${altnames+x} ]; then
    subjectaltdn_addext=""
else
    subjectaltdn_addext="-addext subjectAltName=$altnames"
fi

echo "+++ New server ca cert: $subject webserver root +++"
openssl req -new -config $SCRIPT_DIR/selfsignedcerts.cnf \
        -subj "$subject" \
        $subjectaltdn_addext \
        -key ${serverfile}.key| \
        openssl x509 -req -extfile $SCRIPT_DIR/selfsignedcerts.cnf \
            -CAserial ${servercafile}.srl \
            -CA ${servercafile}.pem \
            -CAkey ${servercafile}.key \
            -extensions server_cert \
            -copy_extensions copy \
            -ext subjectAltName \
            -days "${cert_days}" \
            -setalias "${cn}" -out ${serverfile}.pem      
openssl x509 -outform der -in ${serverfile}.pem  -out ${serverfile}.der
chgrp $group ${serverfile}.key ${serverfile}.pem ${serverfile}.der 
chmod 640 ${serverfile}.key
chmod 644 ${serverfile}.pem ${serverfile}.der 

# you can check cert with
# openssl x509 -text -in <certfile>.pem
