# un-official strict mode
set -euo pipefail

export DBNAME=${WORDPRESS_DB_NAME:-wordpress}
export DBUSER=${WORDPRESS_DB_USER:-$DB_ENV_MYSQL_USER}
export DBPASS=${WORDPRESS_DB_PASS:-$DB_ENV_MYSQL_PASS}
export DBHOST=${WORDPRESS_DB_HOST:-db}

runuser -u www-data -- wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --dbhost=$DBHOST --extra-php <<PHP
define('DISABLE_WP_CRON', 'true');
PHP
