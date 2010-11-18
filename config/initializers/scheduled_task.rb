require 'rubygems'
require 'rufus/scheduler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

scheduler = Rufus::Scheduler.start_new

scheduler.every("10s") do
  puts Time.now
  #  Rake::Task["build"].reenable
  #  Rake::Task["shell:contracts:expiration_check"].invoke
  to_be_expired = License.find :all,
    :conditions => ['expired_on > ? and expired_on < ? ', Time.now, 1.week.from_now]
  puts to_be_expired.size
end