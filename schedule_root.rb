every "*/10 * * * *" do
  command "/usr/local/bin/unison sync > /dev/stdout 2>&1"
end
