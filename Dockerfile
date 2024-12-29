FROM debian:stable-slim

ARG VERSION=2.5.22

# Install requirements
RUN apt-get update \
 && apt-get install -y curl

# Download & Install UrBackup client
RUN curl -L -o /tmp/install.sh https://hndl.urbackup.org/Client/${VERSION}/UrBackup%20Client%20Linux%20${VERSION}.sh \
 && sh /tmp/install.sh silent \
 && /etc/init.d/urbackupclientbackend stop \
 && rm /tmp/install.sh

COPY --chmod=755 start.sh /start.sh

ENTRYPOINT ["/start.sh"]

