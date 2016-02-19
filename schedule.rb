# daily
every "2 2 * * *" do
  command "runuser -u www-data -- wp cron event list --fields=hook,recurrence | grep \"1 day\" | cut -f 1 | xargs runuser -u www-data -- wp cron event run > /dev/stdout 2>&1"
  command "runuser -u www-data -- wp db export /database-backups/daily.sql > /dev/stdout 2>&1"
end

# hourly
every "* * * * *" do
  command "runuser -u www-data -- wp cron event list --fields=hook,recurrence | grep \"1 hour\" | cut -f 1 | xargs runuser -u www-data -- wp cron event run"
  command "runuser -u www-data -- wp db export /database-backups/hourly.sql > /dev/stdout 2>&1"
end

# twice a day
every "12 */12 * * *" do
  command "runuser -u www-data -- wp cron event list --fields=hook,recurrence | grep \"12 hours\" | cut -f 1 | xargs runuser -u www-data -- wp cron event run > /dev/stdout 2>&1"
end

# weekly
every "25 2 * * 0" do
  command "runuser -u www-data -- wp db export /database-backups/weekly.sql > /dev/stdout 2>&1"
end

# monthly
every "25 2 2 * *" do
  command "runuser -u www-data -- wp db export /database-backups/monthly.sql > /dev/stdout 2>&1"
  #command "/usr/bin/mysqldump -h\"$DBHOST\" -u\"$DBUSER\" -p\"$DBPASS\" $DBNAME > /database-backups/$DBNAME.sql"
end
