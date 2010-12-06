ENV["RAILS_ENV"] = "test"

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'

require 'active_record'
require 'active_record/version'
require 'active_record/fixtures'

require 'test/unit'
require 'shoulda'

require File.dirname(__FILE__) + '/../init.rb'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite'])
ActiveRecord::Migration.verbose = false

load(File.dirname(__FILE__) + "/db/schema.rb")