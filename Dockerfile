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
    apt-transport-https \ 
    wget && \
    apt-get clean

# INSTALL ODBC
# More specifically, the Microsoft driver
RUN wget https://packages.microsoft.com/keys/microsoft.asc -O microsoft.asc && \
  apt-key add microsoft.asc && \
  wget https://packages.microsoft.com/config/debian/9/prod.list -O prod.list && \
  cp prod.list /etc/apt/sources.list.d/mssql-release.list && \
  apt-get update && \
  ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev

# Installing Python and Python packages
RUN apt-get -y install python3 python3-pip
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN python3 -m pip install minio
RUN python3 -m pip install pyhdb
RUN python3 -m pip install pyodbc
RUN python3 -m pip install pandas

# Build in startup script 
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Run startup script 
CMD ["/usr/local/bin/startup.sh"]