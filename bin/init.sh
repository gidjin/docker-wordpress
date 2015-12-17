#!/bin/bash -l

# un-official strict mode
set -euo pipefail

if [[ ${AUTHORIZED_SYNC_PRIVATE_KEY} != "" ]] ; then
  echo $AUTHORIZED_SYNC_PRIVATE_KEY | tr -- "|" "\n" > ~/.ssh/sync_rsa
  chmod 600 ~/.ssh/sync_rsa
fi

/usr/sbin/cron
/usr/local/rvm/gems/ruby-2.2.3/bin/whenever -u www-data -w -f /schedule.rb
/usr/local/bin/msmtprc_generator.rb

exec /run.sh
