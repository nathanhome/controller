FROM homeassistant/home-assistant:2024.5

LABEL version="2024.5-1" \
      description="Secure homeassistant setup for NATHAN@home" \
      maintainer="rbe-git@t-online.de"

###
# Security and setup changes to standard image
#

# re-wire secrets to docker-compose injected secrets, by soft link
# and set up for the S6 overlay system used by homeassistant
COPY ./runwithsecrets.sh  /bin
RUN chmod +x /bin/runwithsecrets.sh

EXPOSE 4443/tcp

# we overrride the s6-overlay init to run our scripts before homeassistant starts
ENTRYPOINT ["/bin/runwithsecrets.sh"]