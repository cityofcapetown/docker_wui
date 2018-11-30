FROM nginx:1.15.6

LABEL maintainer="Gordon Inggs <gordon.inggs@capetown.gov.za>"

# Disabling interactivity
ARG DEBIAN_FRONTEND=noninteractive

# Install base utility packages
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get update

RUN apt-get -qq install apt-utils tzdata
RUN ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y \
    git \
    gnupg \
    htop \
    apt-transport-https && \
    apt-get clean

# Installing Python and Python packages
RUN apt-get -y install python3 python3-pip
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN python3 -m pip install minio
RUN python3 -m pip install pandas

# Build in startup script 
COPY startup.sh /
RUN chmod +x /startup.sh

# Run startup script on start 
CMD ["/bin/bash", "./startup.sh"]
