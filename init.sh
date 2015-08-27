#!/bin/bash
set -e

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
  /usr/local/bin/msmtprc_generator.rb
fi

exec "/entrypoint.sh $@"
