require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup { @user = Factory(:user) }

    context "Delivering password instructions" do
      setup { @user.deliver_password_reset_instructions! }

      should_change("perishable token") { @user.perishable_token }
      should "send an email" do
        assert_sent_email
      end
    end
  end
end

