FROM php:8.2-apache

# Configure PHP

# 1. Standard-Produktionskonfiguration von PHP als Basis aktivieren
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 2. Deine eigenen PHP-Parameter in den conf.d-Ordner kopieren
COPY ./custom.ini $PHP_INI_DIR/conf.d/custom.ini


# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libldap2-dev \
    libzip-dev \
    zlib1g-dev \
    libonig-dev \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo_mysql \
        mysqli \
        ldap \
        zip \
        mbstring \
        exif

# Holt das offizielle Installations-Skript
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Installiert intl und imap mitsamt aller nötigen Systempakete im Hintergrund
RUN install-php-extensions intl imap

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Download and extract LimeSurvey source code (using the master branch or a specific release tag)
RUN curl -sSL https://github.com/LimeSurvey/LimeSurvey/archive/refs/heads/master.tar.gz -o /tmp/limesurvey.tar.gz \
    && mkdir -p /var/www/html \
    && tar -xzf /tmp/limesurvey.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/limesurvey.tar.gz

# Set proper permissions for the Apache web server user
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
