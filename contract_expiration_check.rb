require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'date'
require 'active_support'



task :shell_check => :environment do |t|
        current = Date.jd(DateTime.now.jd)
        puts current
  #      contracts = Archive.find :all, :contidion => "expired_at < Time.now.'' do
end
