#!/bin/bash

# Update and upgrade system packages
apt update && apt upgrade -y

# Install and configure Nginx
apt install nginx -y
systemctl start nginx 
systemctl enable nginx

# Install PHP and necessary extensions
apt-get install php php-dev php-fpm php-bcmath php-intl php-soap php-zip php-curl php-mbstring php-mysql php-gd php-xml -y

# Display PHP version and loaded configuration file
php -v
php --ini | grep "Loaded Configuration File"

# Modify PHP settings in php.ini
sed -i 's/^file_uploads = .*/file_uploads = On/' /etc/php/8.1/cli/php.ini
sed -i 's/^allow_url_fopen = .*/allow_url_fopen = On/' /etc/php/8.1/cli/php.ini
sed -i 's/^short_open_tag = .*/short_open_tag = On/' /etc/php/8.1/cli/php.ini
sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php/8.1/cli/php.ini
sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 128M/' /etc/php/8.1/cli/php.ini
sed -i 's/^max_execution_time = .*/max_execution_time = 3600/' /etc/php/8.1/cli/php.ini

# Restart Nginx to apply changes
systemctl restart nginx

# Install MySQL server and configure
apt install mysql-server -y
systemctl start mysql
systemctl enable mysql

# Create MySQL database and user
mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE magentodb;
CREATE USER 'magentouser'@'localhost' IDENTIFIED BY 'MyPassword';
GRANT ALL ON magentodb.* TO 'magentouser'@'localhost';
FLUSH PRIVILEGES;
EXIT
MYSQL_SCRIPT

# Install and configure Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt-get update
sudo apt-get install elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch


# Configure Elasticsearch security features
sudo sed -i 's/^xpack.security.enabled: true/xpack.security.enabled: false/' /etc/elasticsearch/elasticsearch.yml
systemctl restart elasticsearch.service

# Verify Elasticsearch installation
curl -X GET "localhost:9200/"

# Your Magento authentication keys
public_key="26c8681af8d2b2f688b96407f7825288"
private_key="2b95772f5daefad3342f48550cc4fc28"

# Create auth.json file with Magento authentication keys
echo '{
  "http-basic": {
    "repo.magento.com": {
      "username": "'"$public_key"'",
      "password": "'"$private_key"'"
    }
  }
}' > auth.json

# Update and upgrade system packages
apt update && apt upgrade -y

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
composer --version


# Install Magento using Composer with authentication keys
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.6 /var/www/magento2


# Set permissions for Magento
cd /var/www/magento2
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
chown -R www-data:www-data /var/www/magento2
chmod -R 755 /var/www/magento2

# Run Magento setup
bin/magento setup:install \
  --base-url=http://fir3eye.in \
  --db-host=localhost \
  --db-name=magentodb \
  --db-user=magentouser \
  --db-password=MyPassword \
  --admin-firstname=Admin \
  --admin-lastname=User \
  --admin-email=admin@your-domain.com \
  --admin-user=admin \
  --admin-password=admin123 \
  --language=en_US \
  --currency=USD \
  --timezone=America/Chicago \
  --use-rewrites=1

# Display Magento setup output
echo "Magento setup completed."

# Restart Nginx
systemctl restart nginx
