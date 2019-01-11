# docker_wui

This docker image is based on `nginix 1.15.6`, which itself is based on `debian-slim` (which is version 9 AKA Stretch).

It provides the following:
* Nginx serving up at port `80`
* A refresh script for mirroring the content in a READ ONLY Minio bucket.

It also has access logging turned on by default, and this is piped through to the docker logs interface.

The intention is that this container will be used to serve up static content and WUIs securely.

## Usage
### Bringing the webserver up
* Run the Docker container as per normal: `docker run -d -p <Port to expose Nginx>:80 -e CONTENT_URL=<Path to READ ONLY Minio bucket with content> docker_wui:latest -n <container name>`

### Copying in Data

#### Via Docker
* Use the docker copy command: `docker cp <path to files to copy>/. <container image ID or name>:/usr/share/nginx/html/`

#### Via `db-utils` 
`NO LONGER SUPPORTED`
* Copy a secrets file into the container: `docker cp <path to secrets file> <container image ID or name>:/tmp/`
* Use the docker exec command to run the utility script in the docker container: `docker exec <container image ID or name> PYTHONPATH=/usr/share/nginx/db-utils python3 /home/nginx/db-utils/bin/minio_bucker_dir_sync.py -s minio://<bucket name> -c <city classification> -d /usr/share/nginx/html/<any additional path goes here> -x /tmp/secrets.json`

#### Via `refresh.sh`
* When the container starts up, specify the environmental variable `CONTENT_URL`, pointing to a READ ONLY minio bucket with the content.
* At any type the content may be refreshed by rerunning the script, i.e. `docker exec -it <container ID/name> sh -c "/refresh.sh"`
* The script also accepts positional arguments, i.e. `docker exec -it <container ID/name> sh -c "/refresh.sh CONTENT_URL CONTENT_DIR"`

#### Copying out Data

#### Via Docker
* Use the docker logs command: `docker logs <container ID or name>`
