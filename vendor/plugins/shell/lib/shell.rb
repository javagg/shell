module Shell
  module Options
    def self.department_options
      %w(FN OP HR EN HSSE).map(&:to_sym)
    end
    
    def self.shifou_options
      { I18n.t('txt.shi') => true, I18n.t('txt.fou') => false }
    end
    
    def self.confidential_level_options
      [ I18n.t('txt.confidential_high'), I18n.t('txt.confidential_low')].map(&:to_sym)
    end
    
    def self.document_status_options
      %w(FN OP HR EN HSSE).map(&:to_sym)
    end
    
    def self.stamp_tax_type_options
      [ I18n.t('txt.buying_and_selling'), I18n.t('txt.lease'), I18n.t('txt.investigation'), 
        I18n.t('txt.construction_safety'), I18n.t('contractor_agreement'),
        I18n.t('transportation'), I18n.t('storage'), I18n.t('technology') ].map(&:to_sym)
    end

    def self.contract_type_options
      [ I18n.t('txt.station_contract'), I18n.t('txt.purchase_contract') ].map(&:to_sym)
    end
    
    def self.trading_mode_options
      [ I18n.t('txt.purchase'), I18n.t('txt.lease') ].map(&:to_sym)
    end
  end
  
  module Authorized
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
    
    module ClassMethods
      def acts_as_authorized
        has_many permissions.to_sym
        has_many :involved_ycroles, :through => permissions.to_sym, :source => :ycrole

        named_scope :readable_by_user, lambda { |user| {
            :joins => { :involved_ycroles => :user_ycroles },
            :conditions =>  "#{permissions}.can_read = true OR #{permissions}.can_write = true and user_ycroles.user_id = #{user.id}"
          }
        }

        named_scope :readable2_by_user, lambda { |user| {
            :joins => "INNER JOIN #{permissions} ON #{permissions}.#{model}_id = #{models}.id " +
              "INNER JOIN user_ycroles ON #{permissions}.ycrole_id = user_ycroles.ycrole_id ",
            :conditions => "(#{permissions}.can_read = true OR #{permissions}.can_write = true) and user_ycroles.user_id = #{user.id}"
          }
        }

        named_scope :writeable_by_user, lambda { |user| {
            :joins => { :involved_ycroles => :user_ycroles },
            :conditions => { permissions.to_sym => { :can_write => true },
              :involved_ycroles => { :user_ycroles => { :user_id => user.id } }
            }
          }
        }
      end

      def can_read_by_user?(user, id)
        found = self.find(:first,
          :joins => { :involved_ycroles => :user_ycroles },
          :conditions => { models.to_sym => {:id => id }, permissions.to_sym => { :can_read => true },
            :involved_ycroles => { :user_ycroles => { :user_id => user.id }}}
        )

        return true if found
        return false
      end

      def can_write_by_user?(user, id)
        found = self.find(:first,
          :joins => { :involved_ycroles => :user_ycroles },
          :conditions => { models.to_sym => {:id => id }, permissions.to_sym => { :can_write => true },
            :involved_ycroles => { :user_ycroles => { :user_id => user.id }}}
        )

        return true if found
        return false
      end

      def can_create_by_user?(user)
        return user.is_admin?
      end
     
      def authorized_for_create?
        can_create_by_user?(current_user)
      end

      private

      def model
        self.to_s.downcase
      end

      def models
        model.pluralize
      end

      def models
        model.pluralize
      end

      def permissions
        "#{model}_permissions"
      end
    end
    
    module InstanceMethods
      def users_having_permissions_on
        involved_ycroles.collect { |r| r.users }.flatten.uniq
      end

      def can_read_by_user?(user)
        self.class.can_read_by_user?(user, self.id)
      end

      def can_write_by_user?(user)
        self.class.can_write_by_user?(user, self.id)
      end

      def authorized_for_read?
        return can_read_by_user?(current_user)
      end
      #
      def authorized_for_update?
        return can_write_by_user?(current_user)
      end
      
      def authorized_for_delete?
        return can_write_by_user?(current_user)
      end
    end
  end
  
  module Expirable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_expirable
        has_many :expiration_remindings, :as => :reminder, :dependent => :destroy
        has_many :expiration_remindees, :through => :expiration_remindings, :source => 'user'
      end

      def check_expiration
        all_expirings = self.find :all
        all_expirings.each do |expiring|
          expired_on = expiring.expired_on
          if expired_on and expired_on > Date.today and expired_on < Date.today  + expiration_reminding_days
            expiring.remind_expiaration
          end
        end
      end

      def expiration_reminding_days
        0
      end
    end

    attr_accessor :expired_on

    module InstanceMethods
      def remind_expiaration
        expiration_remindees.each do | remindee |
          Emailer.deliver_expiration_reminding self, remindee
        end
      end
      
      def expired?
        return false if expired_on.nil?
        return expired_on < Date.today
      end

      def expiring?
        return false if expired?
        return  Date.today >= expired_on - expiration_reminding_days && Date.today <= expired_on
      end


    end
  end

  module Attachable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_attachable
        has_many :attachments, :as => :attachable, :dependent => :destroy
      end
    end

    module InstanceMethods

    end
  end

  module PaymentRemindable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_payment_remindable
        has_many :payment_remindings, :dependent => :destroy
        has_many :payment_reminders, :through => :payment_remindings, :source => :contract
      end
    end

    module InstanceMethods
      def reject_payment_remindings(contract)
        remindings = PaymentReminding.find(:all,
          :conditions => [ "contract_id = ? and user_id = ?", contract.id, self.id])
        remindings.each do |reminding|
          reminding.update_attributes(:remindee_rejected => true)
        end
      end
    end
  end

  module ExpirationRemindable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_expiration_remindable
        # redefine it to get rid of the annoying depreciation messages
        def returning(value)
          yield(value)
          value
        end
        
        has_many :expiration_remindings, :dependent => :destroy
        has_many :contract_expiration_remindings, :class_name => "ExpirationReminding", :conditions => ["reminder_type = ?", 'Contract']
        has_many :license_expiration_remindings, :class_name => "ExpirationReminding", :conditions => ["reminder_type = ?", 'License']
        has_many :archive_expiration_remindings, :class_name => "ExpirationReminding", :conditions => ["reminder_type = ?", 'Archive']
        has_many_polymorphs :reminders, :from => [:contracts, :archives, :licenses], :through => :expiration_remindings, :dependent => :destroy
      end
    end

    module InstanceMethods
      def reject_expiration_remindings(reminder)
        remindings = ExpirationReminding.find(:all,
          :conditions => [ "reminder_id = ? and reminder_type = ? and user_id = ?",
            reminder.id, reminder.class.to_s, self.id])
        remindings.each do |reminding|
          reminding.update_attributes(:remindee_rejected => true)
        end
      end
    end
  end
end