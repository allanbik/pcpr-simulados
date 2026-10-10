FROM php:8.2-apache

# Habilitar extensão pdo_mysql e mod_rewrite do Apache
RUN docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

# Ajustar permissões para o Apache
WORKDIR /var/www/html
COPY . /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]
