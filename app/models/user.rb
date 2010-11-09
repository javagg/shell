
class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of   :username
  validates_length_of     :username, :within => 3..40
  validates_uniqueness_of :username
  
  validates_presence_of   :email
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  attr_accessible :username, :email, :password, :password_confirmation, :openid_identifier

  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments


  # Authorization section
  # for CanCan
  ROLES = %w[admin moderator author banned]

  # for Declarative Authorization
  def role_symbols
    @role_symbols ||= (roles || []).map {|r| r.to_sym}
  end
  
  def after_destroy
    if User.count.zero?
      raise I18n.t 'user.cannot_delete_last_user'
    end
  end

  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Emailer.deliver_activation_instructions self
  end

  def deliver_welcome!
    reset_perishable_token!
    Emailer.deliver_welcome self
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Emailer.deliver_password_reset_instructions self
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

