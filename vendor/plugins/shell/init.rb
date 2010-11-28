require File.dirname(__FILE__) + "/lib/shell.rb"

ActiveRecord::Base.send :include, Shell::Expirable
ActiveRecord::Base.send :include, Shell::Attachable
ActiveRecord::Base.send :include, Shell::ExpirationRemindable
ActiveRecord::Base.send :include, Shell::PaymentRemindable

