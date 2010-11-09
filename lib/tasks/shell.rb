require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'date'
require 'active_support'

namespace :shell do
  namespace :contracts do
    task :expiration_check => :environment do |t|
      puts 1.week.from_now
#      archives = Archive.find :all,
#        :conditions => ['expired_at > ? and expired_at < ? ', Time.now, 1.week.from_now]
#      if archives
#
#      end
#      puts archives
    end
  end
end
