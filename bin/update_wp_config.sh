#!/bin/bash

cp /app/wp-config-sample.php /app/wp-config.php

# see http://stackoverflow.com/a/2705678/433558
sed_escape_lhs() {
  echo "$@" | sed 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
  echo "$@" | sed 's/[\/&]/\\&/g'
}
php_escape() {
  php -r 'var_export((string) $argv[1]);' "$1"
}
set_config_non() {
  key="$1"
  value="$2"
  regex="(['\"])$(sed_escape_lhs "$key")\2\s*,"
  sed -ri "s/($regex\s*)(['\"]).*\3/\1 $value/" /app/wp-config.php
}
set_config() {
  key="$1"
  value="$2"
  regex="(['\"])$(sed_escape_lhs "$key")\2\s*,"
  if [ "${key:0:1}" = '$' ]; then
    regex="^(\s*)$(sed_escape_lhs "$key")\s*="
  fi
  sed -ri "s/($regex\s*)(['\"]).*\3/\1$(sed_escape_rhs "$(php_escape "$value")")/" /app/wp-config.php
}

set_config_non 'DB_HOST' "getenv('DB_HOST')"
set_config_non 'DB_PORT' "getenv('DB_PORT')"
set_config_non 'DB_USER' "getenv('DB_USER')"
set_config_non 'DB_PASSWORD' "getenv('DB_PASS')"
set_config_non 'DB_NAME' "getenv('DB_NAME')"

# allow any of these "Authentication Unique Keys and Salts." to be specified via
# environment variables with a "WORDPRESS_" prefix (ie, "WORDPRESS_AUTH_KEY")
UNIQUES=(
  AUTH_KEY
  SECURE_AUTH_KEY
  LOGGED_IN_KEY
  NONCE_KEY
  AUTH_SALT
  SECURE_AUTH_SALT
  LOGGED_IN_SALT
  NONCE_SALT
)
for unique in "${UNIQUES[@]}"; do
  eval unique_value=\$WORDPRESS_$unique
  if [ "$unique_value" ]; then
    set_config "$unique" "$unique_value"
  else
    # if not specified, let's generate a random value
    current_set="$(sed -rn "s/define\((([\'\"])$unique\2\s*,\s*)(['\"])(.*)\3\);/\4/p" /app/wp-config.php)"
    if [ "$current_set" = 'put your unique phrase here' ]; then
      set_config "$unique" "$(head -c1M /dev/urandom | sha1sum | cut -d' ' -f1)"
    fi
  fi
done

awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' /app/wp-config.php > /tmp/wp-config.php <<'EOPHP'
define('DISABLE_WP_CRON', 'true');

EOPHP

mv /tmp/wp-config.php /app/wp-config.php
