require 'rubygems'
require 'rufus/scheduler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

scheduler = Rufus::Scheduler.start_new

scheduler.every("1d") do
  puts Time.now
  p "checking if there are some expiring licenses, and remind some one to take care of them..."
  License.check_expiration
  puts "done"
end