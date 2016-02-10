#!/bin/bash
set -e

if [[ "$1" == apache* ]]; then
  # /usr/local/bin/etcd_updater_service.rb start
  /usr/local/bin/wp_config_install.sh
  /usr/local/bin/msmtprc_generator.rb
fi

exec "$@"
