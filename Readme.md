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

#### Nginx basic auth
This image allows for automatic configuration of http basic_auth. To enable http basic_auth, pass an `HTPASSWD` environmental variable in the `docker run` command. 

The `HTPASSWD` variable must be of the format `'user:$1$xxxxxxxx$i7i9OZMOHPzwIC5/ehhFM/'` where `foo` is the username and `user:$1$xxxxxxxx$i7i9OZMOHPzwIC5/ehhFM/` is the **hashed** password of the user foo. 

* Cleartext passwords will not work. 
* **Encapsulate your user:password string in single quotes!**

Here is a sample `docker run` command, which sets up basic auth with the user `user` and password `donald_duck`:

`docker run -d -p <Port to expose Nginx>:80 -e HTPASSWD='user:$1$xxxxxxxx$i7i9OZMOHPzwIC5/ehhFM/' -e CONTENT_URL=<Path> docker_wui:latest -n <container name>`

#### Backdoor
THe maintainers of this Docker image have created an `ENV` flag to add a backdoor `foo` user to the http basic_auth. If you set the environmental variable `BACKDOOR` to `yes` then the backdoor will be enabled. The backdoor is disabled by default. 

If you want to fork this repo and remove the backdoor, remove this offending code block from `startup.sh`:

```
if [ $BACKDOOR == "yes" ]
  then
  echo "$(date -Iminutes) WARNING: Adding backdoor user!"
  echo 'foo:$1$xxxxxxxx$X5WIzadvlkwenviwonbevpin.' >> /etc/nginx/.htpasswd
fi
```

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
