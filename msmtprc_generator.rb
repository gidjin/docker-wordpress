#!/usr/bin/env ruby

require 'erb'
require 'fileutils'

server_finger_print = nil
account_name = 'gmail'
account_host = 'smtp.gmail.com'
account_port = 587
account_from = 'your@emailaddress'
account_user = 'your@emailaddress'
account_pass = 'yourpasswordhere'


ENV.each do |name, value|
 unless %r/^\*\*(?:Change|Link)Me\*\*$/.match value
   if name == 'MSMTP_FINGER_PRINT'
     server_finger_print = value
   elsif name == 'MSMTP_ACCOUNT_NAME'
     account_name = value
   elsif name == 'MSMTP_ACCOUNT_HOST'
     account_host = value
   elsif name == 'MSMTP_ACCOUNT_PORT'
     account_port = value
   elsif name == 'MSMTP_ACCOUNT_FROM'
     account_from = value
   elsif name == 'MSMTP_ACCOUNT_USER'
     account_user = value
   elsif name == 'MSMTP_ACCOUNT_PASS'
     account_pass = value
   end
 end
end

puts "Rendering msmtprc"
renderer = ERB.new(File.read("/templates/msmtprc.erb"))
File.write("/usr/local/etc/msmtprc", renderer.result())
FileUtils.chmod("u=rw,go-rw", "/usr/local/etc/msmtprc", :verbose => true)
FileUtils.chown("www-data", "www-data", "/usr/local/etc/msmtprc", :verbose => true)
