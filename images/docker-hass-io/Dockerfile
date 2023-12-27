FROM homeassistant/home-assistant:2023.12

LABEL version="2023.12-1" \
      description="Secure homeassistant setup for NATHAN@home" \
      maintainer="rbe-git@t-online.de"

###
# Security and setup changes to standard image
#

# re-wire secrets to docker-compose injected secrets, by soft link
RUN ln -s /run/secrets/hass_secrets /config/secrets.yaml

EXPOSE 4443/tcp
