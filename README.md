# z-push-docker

Below is an example `docker-compose.yml` file that mounts configuration files for Z-Push, Nginx, and PHP from the host machine:

### Updated `docker-compose.yml`:
```yaml
services:
  zpush:
    image: gabrieletassoni/z-push-imap:latest
    ports:
      - "8880:80"
    volumes:
      - ./z-push/z-push.conf.php:/etc/z-push/z-push.conf.php
      - ./z-push/imap.conf.php:/etc/z-push/imap.conf.php
    restart: unless-stopped
```

With this setup, you can manage the configuration files on the host machine and mount them into the container at runtime. This approach allows you to update the configuration without rebuilding the Docker image.

The config files in the expected locations are:
- `./z-push/z-push.conf.php` for the main Z-Push configuration.
- `./z-push/imap.conf.php` for the IMAP backend configuration.

In the z-push directory in this repository, you will find sample configuration files for Z-Push and the IMAP backend. You can adjust these files according to your specific environment.

### Building and Running:
To build and run the container with the mounted configuration:

```bash
# Build the Docker image
docker-compose build --no-cache

# Start the container
docker-compose up -d
```

Access Z-Push at `http://localhost:8880/Microsoft-` to verify it is running.