#!/bin/bash

awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' /usr/src/wordpress/wp-config-sample.php > /tmp/wp-config-sample.php <<'EOPHP'
define('DISABLE_WP_CRON', 'true');

EOPHP

mv /tmp/wp-config-sample.php /usr/src/wordpress/wp-config-sample.php
