require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/shell'

class ShellTest < ActiveSupport::TestCase
  class Expirable < ActiveRecord::Base
    include Shell::Expirable
    include Shell::Attachable
  end

  class Remindee < Object
    def initialize(email)
      @email = email
    end
    attr_accessor :email
  end
  
  def test_expiration
    expirable = Expirable.new
    expirable.expiring_days = 10
    expirable.expired_on = Date.today - 1
    assert expirable.expired?
    assert !expirable.expiring?

    expirable.expired_on = Date.today
    assert !expirable.expired?
    assert expirable.expiring?
    
    expirable.expired_on = Date.today + 1
    assert !expirable.expired?
    assert expirable.expiring?
    
    expirable.expired_on = Date.today + expirable.expiring_days + 1
    assert !expirable.expired?
    assert !expirable.expiring?

    expirable.expired_on = Date.today + expirable.expiring_days
    assert !expirable.expired?
    assert expirable.expiring?
  end

  def test_expiration_remind
#    expirable = Expirable.new
#    a_remindee = Remindee.new('lu.lee05@gmail.com')
#    expirable.expiration_remindees << a_remindee
#    expirable.remind_expiaration
  end
end
