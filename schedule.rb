every "16 */6 * * *" do
  command "cd /app/ && php -q wp-cron.php > /dev/stdout 2>&1"
end
