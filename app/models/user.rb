class User < ActiveRecord::Base
  acts_as_audited :except => [ :salt, :persistence_token, :single_access_token, :perishable_token, :login_count,
    :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip,
    :last_login_ip
  ]

  acts_as_authentic
  acts_as_expiration_remindable
  acts_as_payment_remindable

  validates_presence_of   :username
  validates_length_of     :username, :within => 3..40
  validates_uniqueness_of :username
  
  validates_presence_of   :email
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  has_many :contracts
  has_many :licenses
  has_many :archives
  
  named_scope :active, :conditions => { :active => true }
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }

  has_and_belongs_to_many :roles

  has_many :user_ycroles
  has_many :ycroles, :through => :user_ycroles
  has_many :public_ycroles, :source => :ycrole, :through => :user_ycroles,
    :conditions => {:ycroles => {:type => "public"}}
  
  after_create :create_private_ycrole
  before_destroy :destroy_private_ycrole
  
  def has_role?(role)
    role_symbols.include?(role)
  end

  # for Declarative Authorization
  def role_symbols
    @role_symbols ||= roles.map { |r| r.name.to_sym }
    @role_symbols << "admin".to_sym if is_admin?
    @role_symbols.uniq
  end

  # for Declarative Authorization
  def ycrole_symbols
    @ycrole_symbols ||= ycroles.map { |r| r.name.to_sym }
    @ycrole_symbols << "admin".to_sym if is_admin?
    @ycrole_symbols.uniq
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

  def destroy_private_ycrole
    Ycrole.destroy_all({:type => "private", :name => "#{username}"})
  end
  
  def create_private_ycrole
    # odd!
    # Ycrole.create :type => "private", :name => "#{username}"
    role = Ycrole.new
    role.type = "private"
    role.name = "#{username}"
    role.save
    ycroles << role
    save
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

  def username_authorized_for_update?
    true
  end

  def can_read?(manageable)
    can?(manageable, :read)
  end

  def can?(manageable, method)
    can_method = 'can_'.concat(method.to_s).concat("?").to_sym
    yc_roles.each do |role|
      return true if role.send can_method, manageable
    end
    return false
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
#  public              :boolean(1)      default(FALSE), not null
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

