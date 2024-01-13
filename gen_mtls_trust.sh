#!/bin/bash

###########################################################
#
# Generate trusted cacerts file from pem certificates in different
# formats
#

#set -x

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trustfile="cacerts"-$(date "+%Y%m")
user=$(whoami)
group=$(whoami)

continue_loop=1
while [ $continue_loop -eq 1 ]
do
    case $1 in
        -u | --user ) shift
                        user="$1"
                        shift
                        ;;
        -g | --group ) shift
                        group="$1"
                        shift
                        ;;
        -f | --out  ) shift
                        trustfile="$1"-$(date "+%Y%m")
                        shift
                        ;;
        * ) continue_loop=0
                        ;;
    esac
done

> ${trustfile}.pem
for fileprefix in "$@"
do
    file=${fileprefix}.pem
    if [ ! -f "$file" ]; then
        # if the exact filename does not match: try with the current date stamp
        # for convenience only; you can always override by exact names
        file=${fileprefix}-$(date "+%Y%m").pem
    fi
    (printf "#\n# Cert alias=%s\n# %s\n#\n" \
        "$(openssl x509 -alias -noout -in $file)" \
        "$(openssl x509 -subject -noout -in $file)"; \
        openssl x509 -in $file) >> ${trustfile}.pem
done
openssl crl2pkcs7 -certfile ${trustfile}.pem -nocrl -out ${trustfile}.p7b
openssl x509 -outform der -in ${trustfile}.pem -out  ${trustfile}.der
chown $user:$group ${trustfile}.pem ${trustfile}.p7b ${trustfile}.der
chmod 644 ${trustfile}.pem ${trustfile}.p7b ${trustfile}.der

