require 'rubygems'
require 'net/ssh'
HOST = '202.117.46.233'
USER = 'alex'

Net::SSH.start(HOST, USER) do |ssh|
  puts ssh.exec!("hostname")
end