module Shell
  include I18n
  
  DEPARTMENT_OPTIONS = %w(FN OP HR EN HSSE).map(&:to_sym)
  SHIFOU_OPTIONS = { I18n.t('txt.shi') => true, I18n.t('txt.fou') => false }
  CONFIDENTIAL_LEVEL_OPTIONS = [ I18n.t('txt.confidential_high'), I18n.t('txt.confidential_low')].map(&:to_sym)
  DOCUMENT_STATUS_OPTIONS = %w(FN OP HR EN HSSE).map(&:to_sym)
  STAMP_TAX_TYPE_OPTIONS = [ I18n.t('txt.buying_and_selling'), I18n.t('txt.lease'),
    I18n.t('txt.investigation'),  I18n.t('txt.construction_safety') ].map(&:to_sym)
  CONTRACT_TYPE_OPTIONS = [ I18n.t('txt.station_contract'), I18n.t('txt.purchase_contract') ].map(&:to_sym)
  TRADING_MODE_OPTIONS = [ I18n.t('txt.purchase'), I18n.t('txt.lease') ].map(&:to_sym)

  module Expirable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_expirable
        has_many :remindings, :as => :reminder, :dependent => :destroy
        has_many :expiration_remindees, :through => :remindings, :source => 'user'
      end

      def check_expiration
        all_expirings = self.find :all,
          :conditions => ['expired_on > ? and expired_on < ? ', Time.now, 1.week.from_now]
        all_expirings.each do |expiring|
          expiring.remind_expiaration
        end
      end
    end

    attr_accessor :expired_on, :expiring_days

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
        days = expiring_days
        return  Date.today >= expired_on - days && Date.today <= expired_on
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

  module Remindable
   def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def acts_as_remindable
        has_many :remindings
        has_many :reminders, :through => :remindings
      end
    end

    module InstanceMethods
      def reject(reminder)

      end

      def be_reminded_of?(reminder)
      end
    end
  end
end