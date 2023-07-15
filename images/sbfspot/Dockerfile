FROM debian:bullseye-slim 

LABEL version="1.0"
LABEL description="SBFspot SMA device tracker"

RUN apt-get update \
 && apt-get install -y locales \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8

ENV LANG en_US.utf8

# Install bluetooth 5 / RTL8761B 
# add-apt-repository non-free \
# && apt-get update \
RUN apt-get install -y bluez bluez-tools dbus
# && ln -s /lib/firmware/rtl_bt/rtl8761b_config.bin /lib/firmware/rtl_bt/rtl8761bu_config.bin \
# && ln -s /lib/firmware/rtl_bt/rtl8761b_fw.bin /lib/firmware/rtl_bt/rtl8761bu_fw.bin

# avoid installation of mor epackages
RUN rm -rf /var/lib/apt/lists/*

# setup startup script
COPY --chown=root:root entrypoint.sh .
CMD ./entrypoint.sh

# start container with:
# docker run -ti --privileged --net=host <image-name-id> 
