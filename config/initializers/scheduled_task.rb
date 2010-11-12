require 'rubygems'
require 'rufus/scheduler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

#scheduler = Rufus::Scheduler.start_new
#
#scheduler.every("10s") do
#  puts Time.now
#  #  Rake::Task["build"].reenable
#  #  Rake::Task["shell:contracts:expiration_check"].invoke
#  archives = Archive.find :all,
#    :conditions => ['expired_at > ? and expired_at < ? ', Time.now, 1.week.from_now]
#  puts archives.size
#end