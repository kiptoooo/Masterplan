# 1. Base image with PHP & Composer
FROM php:8.2-cli

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

# 5. Copy all your source (so artisan and composer.json are in place)
COPY . /var/www/html

# 6. Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# 7. Wire up env and generate a key
COPY .env.example .env
RUN php artisan key:generate --force

# 8. Ensure SQLite DB exists & run migrations
RUN touch database/database.sqlite \
 && php artisan migrate --force

# 9. Expose the Render port
EXPOSE 8000

# 10. Start the Laravel dev server
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
