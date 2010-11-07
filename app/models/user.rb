
class User < ActiveRecord::Base
  acts_as_authentic do |c| end

  validates_presence_of   :username
  validates_length_of     :username, :within => 3..40
  validates_uniqueness_of :username
  validates_presence_of   :email
  validates_length_of     :email, :within => 6..100
  validates_uniqueness_of :email
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  attr_accessible :username, :email, :password, :password_confirmation, :openid_identifier

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
