#!/usr/bin/env ruby

require "daemons"

# Become a daemon
Daemons.run("/usr/local/lib/etcd_updater_process.rb")

