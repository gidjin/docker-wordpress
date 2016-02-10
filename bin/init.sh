#!/bin/bash
set -e

/usr/local/bin/wp_config_install.sh

if [[ "$1" == apache* ]]; then
  # /usr/local/bin/etcd_updater_service.rb start
  /usr/local/bin/msmtprc_generator.rb
fi

exec "$@"
