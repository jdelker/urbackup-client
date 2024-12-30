# UrBackup-Client Docker Container Image

This project provides a Docker container image that you can use to run th UrBackup-Client in a containerized environment. The image is designed to work with configurable environment variables and volume mounts to customize its behavior and persist data.

## Features

- A particular image version is bound to a particular UrBackup-Client version for reproducable builds.
- The client is configurable through environment variables (see below)
- Volumes to backup are provided as bind-mounts.

## Usage

You can run the container directly using the `docker run` command or use `docker-compose` for a more flexible setup.
In either case, the client is configured through environment variables.

### Environment Variables

| Environment Variable | Description                       | Default Value
| -------------------- | --------------------------------- | -------------
| `NAME`               | Name of the UrBackup client       | None. A randomly generated name will be used.
| `INTERNET_ONLY`      | Enable "Internet Only Mode"       | False
| `SERVER_URL`         | URL of UrBackup Server (Required for "Internet Only Mode") | 
| `AUTHKEY`            | Auth-Key (Required for "Internet Only Mode") | 
| `SOURCE_*`           | A directory to backup (Repeat for multiple with any suffix) | 

## Volumes

All directories that shall be backed up by the client must be mapped into the container by using volume mounts.
Each mapping must correspond with a matching `SOURCE_*` variable in the environment.

So, for a mapping like `/path/to/local/data:/path/in/container`, you should have an environment variable `SOURCE_DATA=/path/in/container`.
Any type of container volume should do. This even works with NFS-local volumes to backup remote hosts.

## Network Ports

Whether you need to publish the usual UrBackup ports to the ouside of your container, depends pretty much on your particular
scenario.
If the UrBackup client is the only one running on your container host, you probably want to publish the following ports:

| Published Port | Internal Port | Protocol
|----------------|---------------|----------
|35621           |35621          |TCP
|35622           |35622          |UDP
|35623           |35623          |TCP

In cases where the client is run in "Internet Only Mode", no port mapping is required.


### Running with `docker run`

To run the container directly using `docker run`, you can pass the required environment variables and volume mounts. Here's an example:

```bash
docker run -d \
  --name your-container-name \
  -e NAME=name-of-your-client \
  -e INTERNET_ONLY=true \
  -e SERVER_URL=urbackup://host.name
  -e AUTHKEY=client-auth-key
  -e SOURCE_1=/mnt/source-dir-1
  -e SOURCE_2=/mnt/source-dir-2
     ...
  -v /path/to/source/dir1:/mount/source-dir-1 \
  -v /path/to/source/dir2:/mount/source-dir-2 \
     ...
  -p 35621:35621/tcp \
  -p 35622:35622/udp \
  -p 35623:35623/tcp \
  ghcr.io/jdelker/urbackup-client:latest
```

### Running with Docker Compose

Alternatively, you can use `docker-compose` for a more structured and easily configurable setup. Below is an example of a `compose.yml` file to run the container:

```yaml
services:
  your-service-name:
    image: ghcr.io/jdelker/urbackup-client:latest
    container_name: your-container-name
    environment:
      - NAME=name-of-your-client
      - INTERNET_ONLY=true
      - SERVER_URL=urbackup://host.name
      - AUTHKEY=client-auth-key
      - SOURCE_1=/mnt/source-dir-1
      - SOURCE_2=/mnt/source-dir-2
    volumes:
      - /path/to/source/dir1:/mount/source-dir-1
      - /path/to/source/dir2:/mount/source-dir-2
    ports:
      - 35621:35621/tcp
      - 35622:35622/udp
      - 35623:35623/tcp
    restart: unless-stopped
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
```
