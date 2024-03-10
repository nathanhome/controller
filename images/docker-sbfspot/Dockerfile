FROM debian:bookworm-slim 

LABEL version="3.9.7-1" \
      maintainer="rbe-git@t-online.de" \
      description="SBFspot SMA device tracker"

RUN apt-get update \
 && apt-get install -y locales \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8

ENV LANG en_US.utf8

# Install bluetooth 5 / RTL8761B 
# add-apt-repository non-free \
# && apt-get update \
RUN apt-get update && \
    apt-get install -y bluez bluez-tools dbus && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

