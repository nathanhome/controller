ARG build_version="latest"

FROM eclipse-mosquitto:1.6

LABEL version="${build_version}" \
      maintainer="rbe-git@t-online.de" \
      description="Mosquitto broker configured for NATHAN home automation"

# config is always part of the immutable image
COPY mosquitto.conf  /mosquitto/config/mosquitto.conf

# add an immutable user/password setup
#COPY mosquitto.passwd /etc/mosquitto/passwd





