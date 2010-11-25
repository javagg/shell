require 'rubygems'
require 'rufus/scheduler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'
require 'date'

scheduler = Rufus::Scheduler.start_new

scheduler.every("5s") do
  Rails.logger.info "Checking if there are some expiring licenses, and remind some one to take care of them..."
#  License.check_expiration
#  puts "done"
end
