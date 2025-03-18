# Start with an Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php-fpm \
    z-push z-push-backend-combined z-push-backend-caldav z-push-backend-carddav z-push-backend-kopano z-push-backend-imap z-push-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod proxy_fcgi setenvif && \
    a2enconf php8.1-fpm

# Copy configuration files
COPY apache2/sites-available/z-push.conf /etc/apache2/sites-available/z-push.conf

RUN a2ensite z-push.conf && \
    a2dissite 000-default.conf

# Expose ports
EXPOSE 80

# Start services
CMD service php8.1-fpm start && apache2ctl -D FOREGROUND
