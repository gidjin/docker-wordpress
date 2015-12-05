#!/bin/bash -l

# un-official strict mode
set -euo pipefail

/usr/sbin/cron
/usr/local/rvm/gems/ruby-2.2.3/bin/whenever -u www-data -w -f /schedule.rb
/usr/local/bin/msmtprc_generator.rb

exec /run.sh
