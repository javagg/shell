require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/shell'


class ShellTest < ActiveSupport::TestCase
  class Expirable < ActiveRecord::Base
    include Shell::Expirable
    include Shell::Attachable
  end

  class Authorized < ActiveRecord::Base
    include Shell::Authorized
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
end
