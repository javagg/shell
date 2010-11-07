# Provide tasks to load and delete sample data.
require 'active_record'
require 'active_record/fixtures'

namespace :db do
#  DATA_DIRECTORY = "#{RAILS_ROOT}/lib/tasks/sample"
  namespace :sample do
#    TABLES = %w(users  specs  faqs)
#    MIN_USER_ID  =  1000        #  Starting  user  id  for  the  sample  data

    desc "Load sample data"
    task :load => :environment do |t|
#      class_name = nil        #  Use  nil  to  get  Rails  to  figure  out  the  class.
#      TABLES.each do |table_name|
#        fixture = Fixtures.new(ActiveRecord::Base.connection,
#          table_name,  class_name,
#          File.join(DATA_DIRECTORY, table_name.to_s))
#        fixture.insert_fixtures
#        puts "Loaded data from #{table_name}.yml"
#      end
    end
    desc "Remove sample data"
    task :delete => :environment do |t|
#      User.delete_all("id >=  #{MIN_USER_ID}")
#      Spec.delete_all("user_id  >=  #{MIN_USER_ID}")
#      Faq.delete_all(  "user_id  >=  #{MIN_USER_ID}")
    end

    desc "Initalize database"
    taks :init => :environment do |t|
      
    end
  end
end