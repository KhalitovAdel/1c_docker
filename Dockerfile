FROM ubuntu:latest
# Install dependency
RUN apt update \
    && apt install -y imagemagick \
        unixodbc \
        ttf-mscorefonts-installer \
        libgsf-1-114

# Install 1C
COPY ./*.deb ./

RUN dpkg -i 1c-enterprise83-common_* \
    1c-enterprise83-server_* \
    && rm *.deb

# Add logs
RUN mkdir -p /home/usr1cv8/.1cv8/1C/1cv8/conf
COPY ./logcfg.xml /home/usr1cv8/.1cv8/1C/1cv8/conf

# Get access to paths
RUN mkdir /var/log/1C \
    && chown -R usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8 /opt/1C

WORKDIR /var/log/1C
EXPOSE 1540-1541 1560-1591

# Create init script
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

CMD /init.sh init
