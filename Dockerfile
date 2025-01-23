# Start with an Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    software-properties-common \
    wget \
    curl \
    gnupg \
    apt-transport-https \
    lsb-release && \
    add-apt-repository ppa:z-push/stable && \
    apt-get update && \
    apt-get install -y \
    php-cli \
    php-fpm \
    php-soap \
    php-gd \
    php-imap \
    php-curl \
    php-mbstring \
    php-xml \
    php-bcmath \
    php-zip \
    nginx \
    z-push && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Nginx for Z-Push
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup && \
    echo 'user www-data;\n\
worker_processes auto;\n\
pid /run/nginx.pid;\n\
include /etc/nginx/modules-enabled/*.conf;\n\
\n\
events {\n\
    worker_connections 1024;\n\
}\n\
\n\
http {\n\
    sendfile on;\n\
    tcp_nopush on;\n\
    tcp_nodelay on;\n\
    keepalive_timeout 65;\n\
    types_hash_max_size 2048;\n\
\n\
    include /etc/nginx/mime.types;\n\
    default_type application/octet-stream;\n\
\n\
    ssl_protocols TLSv1.2 TLSv1.3;\n\
    ssl_prefer_server_ciphers on;\n\
\n\
    log_format main '\''$remote_addr - $remote_user [$time_local] "$request" '\''\n\
                      '\''$status $body_bytes_sent "$http_referer" '\''\n\
                      '\'"$http_user_agent" "$http_x_forwarded_for"'\'';\n\
\n\
    access_log /var/log/nginx/access.log main;\n\
    error_log /var/log/nginx/error.log warn;\n\
\n\
    gzip on;\n\
    gzip_disable "msie6";\n\
\n\
    include /etc/nginx/conf.d/*.conf;\n\
}\n' > /etc/nginx/nginx.conf && \
    echo 'server {\n\
    listen 80;\n\
    server_name _;\n\
\n\
    root /usr/share/z-push;\n\
    index index.php;\n\
\n\
    location / {\n\
        try_files $uri $uri/ =404;\n\
    }\n\
\n\
    location ~ \.php$ {\n\
        include snippets/fastcgi-php.conf;\n\
        fastcgi_pass unix:/var/run/php/php-fpm.sock;\n\
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\n\
        include fastcgi_params;\n\
    }\n\
\n\
    location ~ /\.ht {\n\
        deny all;\n\
    }\n\
}' > /etc/nginx/conf.d/z-push.conf

# Set permissions for PHP-FPM socket
RUN sed -i 's/^listen = .*/listen = \/var\/run\/php\/php-fpm.sock/' /etc/php/8.1/fpm/pool.d/www.conf && \
    sed -i 's/^;listen.owner = .*/listen.owner = www-data/' /etc/php/8.1/fpm/pool.d/www.conf && \
    sed -i 's/^;listen.group = .*/listen.group = www-data/' /etc/php/8.1/fpm/pool.d/www.conf

# Expose ports
EXPOSE 80

# Start services
CMD service php8.1-fpm start && nginx -g "daemon off;"
