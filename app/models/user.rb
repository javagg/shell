
class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of   :username
  validates_length_of     :username, :within => 3..40
  validates_uniqueness_of :username
  
  validates_presence_of   :email
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  has_and_belongs_to_many :roles

  has_many :remindings
  has_many :reminding_licenses, :through => :remindings, :source => :license,
    :conditions => "remindings.reminder_type = 'License'"

  has_many :reminding_contracts, :through => :remindings, :source => :contract,
    :conditions => "remindings.reminder_type = 'Contract'"


  def has_role?(role)
    role_symbols.include?(role)
  end

  # for Declarative Authorization
  def role_symbols
    @role_symbols ||= roles.map { |r| r.name.to_sym }
    #    #    @role_symbols << "guest".to_sym
    @role_symbols << "admin".to_sym if is_admin?
    @role_symbols.uniq
  end

  def to_label
    username
  end

	def is_admin?
		return username == 'admin'
	end
  
  def before_destroy
    if is_admin?
      raise I18n.t('user.cannot_delete_admin')
    end

    if User.count.zero?
      raise I18n.t('user.cannot_delete_last_user')
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

  def authorized_for_delete?
    return username != "admin"
  end

  def authorized_for_update?
    return username != "admin"
  end
end





# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  username            :string(255)     not null
#  email               :string(255)     not null
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
#  created_at          :datetime
#  updated_at          :datetime
#

