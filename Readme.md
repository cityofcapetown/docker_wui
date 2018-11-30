# docker_wui

This docker image is based on `nginix 1.15.6`, which itself is based on `debian-slim` (which is version 9 AKA Stretch).

It provides the following:
* Nginx
* Python 3
* Python packages: `minio`, `pandas`

On startup, it tries to pull:  
* `db-utils` from [OPM's Gitlab](https://ds1.capetown.gov.za/ds_gitlab/OPM/db-utils)

It also has access logging turned on by default, and this is piped through to the docker logs interface.

The intention is that this container will be used to serve up static content and WUIs securely.

## Usage
### Bringing the webserver up
* Run the Docker container as per normal: `docker run -d -p <Port to expose Nginx>:80 docker_wui:latest -n <container name>`

### Copying in Data

#### Via Docker
* Use the docker copy command: `docker cp <path to files to copy>/. <container image ID or name>:/usr/share/nginx/html/`

#### Via `db-utils`
* Copy a secrets file into the container: `docker cp <path to secrets file> <container image ID or name>:/tmp/`
* Use the docker exec command to run the utility script in the docker container: `docker exec <container image ID or name> PYTHONPATH=/usr/share/nginx/db-utils python3 /home/nginx/db-utils/bin/minio_bucker_dir_sync.py -s minio://<bucket name> -c <city classification> -d /usr/share/nginx/html/<any additional path goes here> -x /tmp/secrets.json`

#### Copying out Data

#### Via Docker
* Use the docker logs command: `docker logs <container ID or name>`
