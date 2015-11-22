#!/bin/bash
set -e

# if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
  # /usr/local/bin/etcd_updater_service.rb start
  /usr/sbin/cron
  /usr/local/bin/whenever -u www-data -w -f /schedule.rb
  /usr/local/bin/msmtprc_generator.rb
# fi

# exec /entrypoint.sh "$@"
exec /run.sh
