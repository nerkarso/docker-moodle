# Use an official PHP image with Apache
FROM php:8.4-apache

# Install system dependencies and PHP extensions required by Moodle
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpq-dev \
    libmariadb-dev \
    libzip-dev \
    libgd-dev \
    libxml2-dev \
    libonig-dev \
    sudo \
    git \
    unzip \
    vim \
    nano \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install -j$(nproc) \
    intl \
    pdo_mysql \
    mysqli \
    zip \
    gd \
    xml \
    opcache \
    soap \
    exif

# Configure PHP settings
RUN echo 'zend.exception_ignore_args = On' >> /usr/local/etc/php/php.ini
RUN echo 'max_input_vars = 5000' >> /usr/local/etc/php/php.ini

# Configure Apache
RUN a2enmod rewrite

# Set DocumentRoot for Moodle 5.0+
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/moodle/public|' /etc/apache2/sites-available/000-default.conf
COPY moodle-apache.conf /tmp/moodle-apache.conf
RUN cat /tmp/moodle-apache.conf >> /etc/apache2/sites-available/000-default.conf

# Set working directory
WORKDIR /var/www/html

# Copy custom Moodle configuration if needed
# COPY moodle_config.php /var/www/html/moodle/config.php

# Expose port 80
EXPOSE 80

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint and command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
