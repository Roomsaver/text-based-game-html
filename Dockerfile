# BASE IMAGE
FROM php:8.0-apache

# GET ESSENTIAL UPDATES AND LATEST SECURITY FOR CONTAINER
RUN apt-get update -y && apt-get upgrade -y

# # NOW GET GNUPG TO ADD KEYS BELOW
# RUN apt-get update -y
# RUN apt-get install -y gnupg2 --fix-missing
# RUN apt-get install -y wget

# # ADD STUFF TO APT THAT ISN'T THERE NORMALLY
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# # GET AGAIN FOR NON-STANDARD STUFF
# RUN apt-get update -y && apt-get upgrade -y

# GET A FILE EDITOR
RUN apt-get install -y nano

# PHP DEPENDENCIES
RUN apt-get install -y libpq-dev
RUN apt-get install -y unixodbc-dev
# RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
# RUN docker-php-ext-install pdo 
# RUN docker-php-ext-install pdo_mysql
# RUN docker-php-ext-install pdo_pgsql
# RUN docker-php-ext-install pgsql
# RUN wget http://pecl.php.net/get/sqlsrv-5.9.0.tgz
# RUN pear install sqlsrv-5.9.0.tgz
# RUN docker-php-ext-enable sqlsrv

# ADD XDEBUG FOR PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "log_errors=on" >> /usr/local/etc/php/php.ini
RUN echo "error_reporting=32767" >> /usr/local/etc/php/php.ini
RUN echo "error_log='/tmp/php_error.log'" >> /usr/local/etc/php/php.ini
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_host=localhost" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_log=usr/local/etc/php/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini

# Copy vscode launch.json for xdebug
RUN mkdir /var/www/html/.vscode
COPY ./configs/launch.json /var/www/html/.vscode

# COPY IN DATA CUSTOM SITE DATA TO FULCRUM WITHIN DOCKER CONTAINER
COPY ./pages/ /var/www/html/
COPY ./scripts/ /var/www/html/scripts
COPY ./styles/ /var/www/html/styles
COPY ./assets/ /var/www/html/assets/

# SET APACHE TO HANDLE URL REWRITE
RUN a2enmod rewrite

# CHANGE OWNERSHIP OF HTML DIR
RUN chown -R www-data:www-data /var/www

# CHANGE SECUIRTY OF HTML DIR
RUN chmod 777 /var/www
