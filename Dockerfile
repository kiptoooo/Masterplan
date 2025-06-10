# 1. Base image with PHP & Composer
FROM php:8.1-cli

# 2. Install system deps for Laravel + SQLite
RUN apt-get update \
 && apt-get install -y \
    libzip-dev zip unzip sqlite3 \
    libsqlite3-dev pkg-config \
 && docker-php-ext-install pdo_sqlite zip

# 3. Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# 4. Set working directory
WORKDIR /var/www/html

# 5. Copy source in and install PHP deps
COPY . /var/www/html
RUN composer install --no-dev --optimize-autoloader

# 6. Ensure SQLite DB exists & run migrations
RUN touch database/database.sqlite \
 && php artisan migrate --force

# 7. Expose the port Render provides
EXPOSE 8000

# 8. Start the Laravel dev server
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
