FROM zwavejs/zwave-js-ui:9.6

LABEL version="9.6-2" \
      maintainer="rbe-git@t-online.de" \
      description="Zwavejs gateway configured for NATHAN home automation"

###
# Security and setup changes to standard image
# To take secret information from dockr-compose secrets
#
COPY ./runwithsecrets.sh /bin/runwithsecrets.sh
RUN chmod +x /bin/runwithsecrets.sh
ENTRYPOINT ["/bin/runwithsecrets.sh"]
CMD ["node", "server/bin/www"]