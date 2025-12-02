# Use the official PHP image with Apache
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && docker-php-ext-install \
    curl

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Copy application files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Enable apache rewrite module
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
