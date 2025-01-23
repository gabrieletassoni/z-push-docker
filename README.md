# z-push-docker

Below is an example `docker-compose.yml` file that mounts configuration files for Z-Push, Nginx, and PHP from the host machine:

### Updated `docker-compose.yml`:
```yaml
services:
  z-push:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    volumes:
      # Mount Z-Push configuration
      - ./z-push/config:/usr/share/z-push/config:ro
      - ./z-push/backend:/usr/share/z-push/backend:ro
      
      # Mount custom Nginx configuration
      - ./nginx/z-push.conf:/etc/nginx/conf.d/z-push.conf:ro
      
      # Mount PHP configuration if needed
      - ./php/php.ini:/etc/php/8.1/fpm/php.ini:ro
      
      # Optional: Custom log directory (useful for debugging)
      - ./logs/nginx:/var/log/nginx
      - ./logs/php:/var/log/php

    environment:
      # Pass necessary environment variables if needed
      TZ: "UTC"  # Set timezone
    restart: unless-stopped
```

### Directory and Configuration Files:
1. **`./z-push/config`**:
   - Place your Z-Push configuration files here, such as:
     - `config.php` for general Z-Push configuration.
     - Backend-specific configurations like `backendIMAP.php`, `backendCalDAV.php`, or `backendCardDAV.php` for connecting to IMAP, SMTP, CalDav, and CardDav.

   Example structure:
   ```
   ./z-push/config/
   ├── config.php
   ├── backendIMAP.php
   ├── backendCalDAV.php
   ├── backendCardDAV.php
   ```

2. **`./nginx/z-push.conf`**:
   - Place a custom Nginx configuration file here for serving Z-Push.

   Example `z-push.conf`:
   ```nginx
   server {
       listen 80;
       server_name _;

       root /usr/share/z-push;
       index index.php;

       location / {
           try_files $uri $uri/ =404;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php-fpm.sock;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include fastcgi_params;
       }

       location ~ /\.ht {
           deny all;
       }
   }
   ```

3. **`./php/php.ini`**:
   - Place custom PHP configuration if needed (e.g., to set timezones or adjust PHP limits).

4. **`./logs`**:
   - Optional directory to store logs for Nginx and PHP.

### Additional Steps:
1. Ensure that the configuration files (like `config.php`, `backendIMAP.php`, etc.) have the correct settings for connecting to your IMAP, SMTP, CalDav, and CardDav services.
2. Make sure the mounted configuration directories/files on the host have the correct permissions to be read by the container (read-only is sufficient).

### Building and Running:
To build and run the container with the mounted configuration:

```bash
# Build the Docker image
docker-compose build

# Start the container
docker-compose up -d
```

### Verification:
1. Access Z-Push at `http://localhost:8080` to verify it is running.
2. Check the logs (e.g., `./logs/nginx/access.log`, `./logs/php/error.log`) for any issues during the setup or runtime.

This setup ensures that you can manage configuration files from the host machine, making it easier to maintain and update them without rebuilding the Docker image.

Below are sample configuration files for `backendIMAP.php`, `backendCalDAV.php`, `backendCardDAV.php`, and `config.php` based on typical Z-Push setups. You should adjust these files according to your specific environment (e.g., IMAP server, CalDAV/CardDAV services, etc.).

---

### Sample `config.php`
```php
<?php
// General Z-Push configuration
define('TIMEZONE', 'UTC'); // Set your desired timezone
define('BACKEND_PROVIDER', 'BackendIMAP'); // Default backend

// Log settings
define('LOGFILEDIR', '/var/log/z-push/');
define('LOGFILE', LOGFILEDIR . 'z-push.log');
define('LOGLEVEL', LOGLEVEL_INFO); // Options: LOGLEVEL_DEBUG, LOGLEVEL_INFO, LOGLEVEL_WARN, LOGLEVEL_ERROR

// IPC settings
define('IPC_PROVIDER', 'IpcSharedMemoryProvider');

// State management
define('STATE_MACHINE', 'FileStateMachine');
define('STATE_DIR', '/var/lib/z-push/');

// Mobile device management
define('USE_FULLEMAIL_FOR_LOGIN', true);
define('ALLOW_SYNC_OBJECTS', true);
define('ALLOW_CONTACTS_SYNC', true);
define('ALLOW_CALENDAR_SYNC', true);

// Max size for incoming attachments
define('SYNC_MAX_ITEMS', 512); // Adjust as needed
define('SYNC_FILESIZE_MAX', 10485760); // 10MB

// Authentication
define('USE_SMTP_AUTH', true);
define('SMTP_SERVER', 'smtp.example.com');
define('SMTP_PORT', 587);
define('SMTP_AUTH', true);
define('SMTP_LOGIN', 'your-smtp-username');
define('SMTP_PASSWORD', 'your-smtp-password');
define('SMTP_SSL', true);

?>
```

---

### Sample `backendIMAP.php`
```php
<?php
// Backend IMAP configuration for Z-Push
define('IMAP_SERVER', 'imap.example.com');
define('IMAP_PORT', 993);
define('IMAP_OPTIONS', '/ssl/novalidate-cert'); // Use "/ssl" for secure connection
define('IMAP_SMTP_METHOD', 'STARTTLS'); // Options: 'SSL', 'STARTTLS', 'NONE'
define('IMAP_SMTP_PORT', 587); // SMTP port for sending emails
define('IMAP_USE_SMTP', true);
define('IMAP_SMTP_LOGIN', 'your-smtp-username');
define('IMAP_SMTP_PASSWORD', 'your-smtp-password');
?>
```

---

### Sample `backendCalDAV.php`
```php
<?php
// Backend CalDAV configuration for Z-Push
define('CALDAV_SERVER', 'https://caldav.example.com'); // Base URL of the CalDAV server
define('CALDAV_PORT', 443); // Port for secure communication
define('CALDAV_PATH', '/principals/users/'); // Adjust to your server's path
define('CALDAV_USER', 'your-caldav-username');
define('CALDAV_PASSWORD', 'your-caldav-password');

// SSL settings
define('CALDAV_SSL_VERIFY_PEER', false); // Set to true for production environments
define('CALDAV_SSL_VERIFY_HOST', false);
?>
```

---

### Sample `backendCardDAV.php`
```php
<?php
// Backend CardDAV configuration for Z-Push
define('CARDDAV_SERVER', 'https://carddav.example.com'); // Base URL of the CardDAV server
define('CARDDAV_PORT', 443); // Port for secure communication
define('CARDDAV_PATH', '/principals/users/'); // Adjust to your server's path
define('CARDDAV_USER', 'your-carddav-username');
define('CARDDAV_PASSWORD', 'your-carddav-password');

// SSL settings
define('CARDDAV_SSL_VERIFY_PEER', false); // Set to true for production environments
define('CARDDAV_SSL_VERIFY_HOST', false);
?>
```

---

### Notes:
1. Replace all instances of `example.com` with your actual server's domain or IP address.
2. Ensure the usernames and passwords match your backend services (IMAP, SMTP, CalDAV, CardDAV).
3. Adjust SSL settings:
   - For production, set `*_SSL_VERIFY_PEER` and `*_SSL_VERIFY_HOST` to `true` to validate SSL certificates.
   - For development with self-signed certificates, set these to `false` but secure the container network.

---

### File Placement:
- Place these files under `./z-push/config` and `./z-push/backend` as per the `docker-compose.yml` structure:
  ```
  ./z-push/config/
  ├── config.php
  ./z-push/backend/
  ├── backendIMAP.php
  ├── backendCalDAV.php
  ├── backendCardDAV.php
  ```

---

### Testing:
1. After running the container, verify that Z-Push can connect to your backend services by checking logs:
   - Z-Push log: `/var/log/z-push/z-push.log`
   - Nginx log: `/var/log/nginx/access.log` or `/var/log/nginx/error.log`
2. Configure your mobile or desktop clients to connect via ActiveSync using the URL of your Z-Push server.
