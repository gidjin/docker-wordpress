# un-official strict mode
set -euo pipefail

dbname=${WORDPRESS_DB_NAME:-wordpress}
dbuser=${WORDPRESS_DB_USER:-$DB_ENV_MYSQL_USER}
dbpass=${WORDPRESS_DB_PASS:-$DB_ENV_MYSQL_PASS}
dbhost=${WORDPRESS_DB_HOST:-$DB_PORT_3306_TCP_ADDR}

runuser -u www-data -- wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass --dbhost=$dbhost --extra-php <<PHP
define('DISABLE_WP_CRON', 'true');
PHP
