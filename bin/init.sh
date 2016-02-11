#!/bin/bash
set -e

/usr/local/bin/wp_config_install.sh
/usr/local/bin/msmtprc_generator.rb

# if [[ "$1" == apache* ]]; then
#   # /usr/local/bin/etcd_updater_service.rb start
# fi

exec "$@"
