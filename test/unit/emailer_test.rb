require File.dirname(__FILE__) + '/../test_helper'

class EmailerTest < Test::Unit::TestCase
  context "delivering password reset instructions" do
    setup do
      @user = Factory(:user)
      @user.deliver_password_reset_instructions!
    end

    should "send an email" do
      assert_sent_email do |email|
        email.subject =~ /Password Reset Instructions/
        email.body =~ /#{@user.perishable_token}/
        email.body =~ /Password Reset Instructions/
      end
    end
  end
end