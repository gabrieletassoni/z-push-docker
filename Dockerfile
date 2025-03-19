# Start with an Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && apt-get install -y \
    php-soap php7.4-common php7.4-soap php7.4-fpm php7.4-imap php7.4-mbstring \
    z-push z-push-backend-imap z-push-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2dismod php8.3 && \
    a2dismod mpm_prefork && \
    a2enmod mpm_event proxy_fcgi setenvif && \
    a2enconf php7.4-fpm

# Copy configuration files
COPY apache2/sites-available/z-push.conf /etc/apache2/sites-available/z-push.conf

RUN a2ensite z-push.conf && \
    a2dissite 000-default.conf

# Expose ports
EXPOSE 80

# Start services
CMD service php7.4-fpm start && apache2ctl -D FOREGROUND
