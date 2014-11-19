#!/bin/bash

echo "Stop apache"
service apache2 stop
echo "Start up apache"
service apache2 start
# If not installed
if [ -e "/var/www/html/wp-config.php" ]
  then
    echo "Generating wp-config.php file"
    rm /var/www/html/wp-config.php
    sudo -u www-data /bin/wp core config
    echo "Skipping wordpress install"
  else
    echo "Generating wp-config.php file"
    sudo -u www-data /bin/wp core config
    echo "Installing wp database data"
    sudo -u www-data /bin/wp core install --title="$SITE_TITLE" --admin_user="$SITE_ADMIN_USER" --admin_password="$SITE_ADMIN_PASS" --admin_email="$SITE_ADMIN_EMAIL"
fi
echo "Wordpress Installed admin user: $SITE_ADMIN_USER"
echo "title: $SITE_TITLE"
