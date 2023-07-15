ARG build_version="latest"

FROM homeassistant/raspberrypi3-homeassistant:stable

LABEL version="${build_version}" \
      description="Secured configuration of homeassistant for NATHAN@home setup" \
      maintainer="rbe-git@t-online.de"

###
# Security and setup changes to standard image
#

EXPOSE 4143/tcp

# TODO: switch homeassitant to non-root venv
# see for basic idea: https://github.com/tribut/homeassistant-docker-venv/blob/master/run