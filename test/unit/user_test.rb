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



# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  username            :string(255)
#  email               :string(255)
#  crypted_password    :string(255)     not null
#  salt                :string(255)     not null
#  active              :boolean(1)      default(FALSE), not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  role                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

