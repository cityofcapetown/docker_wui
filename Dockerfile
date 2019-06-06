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
    gnupg \
    htop \
    curl \
    wget \
    apt-transport-https \
    libxml-xpath-perl \
    nano \
    apache2-utils \
    libxml2-utils && \
    apt-get clean

# Build in startup and refresh scripts
COPY startup.sh /
COPY refresh.sh /
COPY basic_auth.conf /

RUN chmod +x /startup.sh
RUN chmod +x /refresh.sh

ENV CONTENT_URL ""
ENV CONTENT_DIR "/usr/share/nginx/html/"
ENV HTPASSWD ""

# Run startup script on start 
CMD ["/bin/bash", "./startup.sh"]
