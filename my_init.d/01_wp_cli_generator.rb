#!/usr/bin/env ruby

require 'erb'

database_host = "0.0.0.0"
database_port = 3306
database_name = "wordpress"
database_user = nil
database_pass = nil
main_site_url = nil

ENV.each do |name, value|
  unless %r/^\*\*(?:Change|Link)Me\*\*$/.match value
    if name == 'DB_PORT'
      if matches = value.match(%r|tcp://(\d+\.\d+\.\d+\.\d+):\d+|)
        database_host = matches[1]
      end
    elsif name == 'DATABASE_PORT'
      database_port = value
    elsif name == 'DATABASE_NAME'
      database_name = value
    elsif name == 'DATABASE_USER'
      database_user = value
    elsif name == 'DATABASE_PASS'
      database_pass = value
    elsif name == 'MAIN_URL'
      main_site_url = value
    end
  end
end

puts "Rendering wp-cli.yml"
renderer = ERB.new(File.read("/templates/wp-cli.yml.erb"))
File.write("/wp-cli.yml", renderer.result())
