module Shell
  module Options
    def self.department_options
      ["FN", "OP", "EN", "HR", "HSSE"]
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
        I18n.t('txt.construction_safety'), I18n.t('txt.contractor_agreement'),
        I18n.t('txt.transportation'), I18n.t('txt.storage'), I18n.t('txt.technology') ].map(&:to_sym)
    end

    def self.contract_type_options
      [ I18n.t('txt.station_contract'), I18n.t('txt.purchase_contract') ].map(&:to_sym)
    end
    
    def self.trading_mode_options
      [ I18n.t('txt.purchase'), I18n.t('txt.lease') ].map(&:to_sym)
    end
  end
  
  module HasParentAssociation
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def parent_association(sym)
        define_method(:parent_sym) {"#{sym}"}
      end
    end

    module InstanceMethods
      def parent
        p = self.send(parent_sym)
        return p if p
        #        raise "Parent Association is nil"
      end

      def authorized_for_read?
        parent_can_read_by_user?(current_user)
      end

      def authorized_for_update?
        parent_can_write_by_user?(current_user)
      end

      def authorized_for_delete?
        parent_can_write_by_user?(current_user)
      end

      private
      
      def parent_can_write_by_user?(user)
        parent.can_write_by_user?(user) if parent
      end

      def parent_can_read_by_user?(user)
        parent.can_read_by_user?(user) if parent
      end
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
        has_many permissions.to_sym, :dependent => :destroy
        has_many :involved_ycroles, :through => permissions.to_sym, :source => :ycrole

        belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
          
        before_save :set_creator
        
        after_save :add_permissions

        named_sql :readable_by_user, lambda { |user| {
            #            :select=> "DISTINCT #{models}.*",
            #            :joins => "INNER JOIN #{permissions} ON #{permissions}.#{model}_id = #{models}.id " +
            #              "INNER JOIN user_ycroles ON #{permissions}.ycrole_id = user_ycroles.ycrole_id ",
            #            :conditions => "(#{permissions}.can_read = true OR #{permissions}.can_write = true) and user_ycroles.user_id = #{user.id}",
            :scope_sql => "SELECT DISTINCT `#{models}`.* FROM `#{models}`
                           INNER JOIN `#{permissions}` ON (`contracts`.`id` = `#{permissions}`.`contract_id`)
                           INNER JOIN `ycroles` ON (`ycroles`.`id` = `#{permissions}`.`ycrole_id`)
                           INNER JOIN `user_ycroles` ON user_ycroles.ycrole_id = ycroles.id
                           WHERE ((`#{permissions}`.`can_read` = true OR `#{permissions}`.`can_read` = true) AND `user_ycroles`.`user_id` = #{user.id})
                           UNION
                           SELECT DISTINCT `#{models}`.* FROM `#{models}`
                           WHERE (`#{models}`.`user_id` = #{user.id})"
          }
        }
        #
        #        named_scope :readable_by_user_id, lambda { |user_id| {
        #            :select=> "DISTINCT #{models}.*",
        #            :joins => "INNER JOIN #{permissions} ON #{permissions}.#{model}_id = #{models}.id " +
        #              "INNER JOIN user_ycroles ON #{permissions}.ycrole_id = user_ycroles.ycrole_id ",
        #            :conditions => "(#{permissions}.can_read = true OR #{permissions}.can_write = true) and user_ycroles.user_id = #{user_id}"
        #          }
        #        }

        named_scope :created_by_user, lambda { |user| {
            :conditions => ["user_id = ? ", user.id],
          }
        }

        #        named_scope :created_by_user_id, lambda { |user_id| {
        #            :conditions => ["user_id = ? ", user_id]
        #          }
        #        }

        named_scope :writeable_by_user, lambda { |user| {
            :select=> "DISTINCT #{models}.*",
            :joins => "INNER JOIN #{permissions} ON #{permissions}.#{model}_id = #{models}.id " +
              "INNER JOIN user_ycroles ON #{permissions}.ycrole_id = user_ycroles.ycrole_id ",
            :conditions => "(#{permissions}.can_write = true) and user_ycroles.user_id = #{user.id}"
          }
        }
      end
     
      def can_read_by_user?(user, id)

        found = self.find(:first,
          :select=> "DISTINCT #{models}.*",
          :joins => { :involved_ycroles => :user_ycroles },
          :conditions => { models.to_sym => {:id => id }, permissions.to_sym => { :can_read => true },
            :involved_ycroles => { :user_ycroles => { :user_id => user.id }}}
        )

        return true if found
        found = self.find(:first, :conditions => ["user_id = ? and id = ? ", user.id, id])
        return true if found
        return false
      end

      def can_write_by_user?(user, id)

        found = self.find(:first,
          :select=> "DISTINCT #{models}.*",
          :joins => { :involved_ycroles => :user_ycroles },
          :conditions => { models.to_sym => {:id => id }, permissions.to_sym => { :can_write => true },
            :involved_ycroles => { :user_ycroles => { :user_id => user.id }}}
        )

        found = self.find(:first, :conditions => ["user_id = ? and id = ? ", user.id, id])
        return true if found
        return false
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
      def add_permissions
        Ycrole.find(:all).each do |role|
          model_name = self.class.to_s.downcase
          doc_id = "#{model_name.downcase}_id".to_sym
          permissions = self.send("#{model_name}_permissions".to_sym)
          permissions.create doc_id => self.id, :ycrole_id => role.id,
            :can_read => false, :can_write => false
        end
      end
      
      def created_by?(user)
        self.creator == user
      end

      def set_creator
        if current_user.nil?
          creator = User.find_by_username("admin")
        else
          creator = User.find current_user.id
        end

        self.creator = creator unless creator.nil?
        return true
      end
      
      def users_having_permissions_on
        involved_ycroles.collect { |r| r.users }.flatten.uniq
      end

      def can_read_by_user?(user)
        return true if created_by?(user)
        self.class.can_read_by_user?(user, self.id)
      end

      def can_write_by_user?(user)
        return true if created_by?(user)
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

  module CreationAuthorization
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
    module ClassMethods

    end

    module InstanceMethods
      def parent
        parent_model = params[:parent_model]
        # nested_parent_id may changge in the future
        parent_id = nested_parent_id
        return parent_model.constantize.find parent_id
      end

      def create_authorized?
        return parent.can_write_by_user?(current_user) if parent
        return false
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
        #        has_many_polymorphs :reminders, :from => [:contracts, :archives, :licenses], :through => :expiration_remindings, :dependent => :destroy
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

  module ActiveScaffoldConfiguration
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
    module ClassMethods
      def permissions_active_scaffold_configurate(doc_name)
        doc = doc_name.to_sym
        permissions = "#{doc_name}_permissions".to_sym
        in_place_edit_for permissions, :can_read
        in_place_edit_for permissions, :can_write

        active_scaffold permissions do |config|
          config.columns = [ doc, :can_read, :can_write ]
          config.columns[doc].form_ui = :select
          config.show.columns = [doc]
          config.columns[:can_read].form_ui = :select
          config.columns[:can_read].options = { :options => Shell::Options::shifou_options }
          config.columns[:can_read].inplace_edit = true
          config.columns[:can_write].form_ui = :select
          config.columns[:can_write].options = { :options => Shell::Options::shifou_options }
          config.columns[:can_write].inplace_edit = true

          config.actions.exclude :show
          config.actions.exclude :update
        end
      end
    end
  end  
  
  module NamedSql
    # All subclasses of ActiveRecord::Base have one named scope:
    # * <tt>scoped</tt> - which allows for the creation of anonymous \scopes, on the fly: <tt>Shirt.scoped(:conditions => {:color => 'red'}).scoped(:include => :washing_instructions)</tt>
    #
    # These anonymous \scopes tend to be useful when procedurally generating complex queries, where passing
    # intermediate values (scopes) around as first-class objects is convenient.
    #
    # You can define a scope that applies to all finders using ActiveRecord::Base.default_scope.
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def scopes
        read_inheritable_attribute(:scopes) || write_inheritable_attribute(:scopes, {})
      end

      def scoped(scope, &block)
        Scope.new(self, scope, &block)
      end

      # Adds a class method for retrieving and querying objects. A scope represents a narrowing of a database query,
      # such as <tt>:conditions => {:color => :red}, :select => 'shirts.*', :include => :washing_instructions</tt>.
      #
      #   class Shirt < ActiveRecord::Base
      #     named_scope :red, :conditions => {:color => 'red'}
      #     named_scope :dry_clean_only, :joins => :washing_instructions, :conditions => ['washing_instructions.dry_clean_only = ?', true]
      #   end
      #
      # The above calls to <tt>named_scope</tt> define class methods Shirt.red and Shirt.dry_clean_only. Shirt.red,
      # in effect, represents the query <tt>Shirt.find(:all, :conditions => {:color => 'red'})</tt>.
      #
      # Unlike <tt>Shirt.find(...)</tt>, however, the object returned by Shirt.red is not an Array; it resembles the association object
      # constructed by a <tt>has_many</tt> declaration. For instance, you can invoke <tt>Shirt.red.find(:first)</tt>, <tt>Shirt.red.count</tt>,
      # <tt>Shirt.red.find(:all, :conditions => {:size => 'small'})</tt>. Also, just
      # as with the association objects, named \scopes act like an Array, implementing Enumerable; <tt>Shirt.red.each(&block)</tt>,
      # <tt>Shirt.red.first</tt>, and <tt>Shirt.red.inject(memo, &block)</tt> all behave as if Shirt.red really was an Array.
      #
      # These named \scopes are composable. For instance, <tt>Shirt.red.dry_clean_only</tt> will produce all shirts that are both red and dry clean only.
      # Nested finds and calculations also work with these compositions: <tt>Shirt.red.dry_clean_only.count</tt> returns the number of garments
      # for which these criteria obtain. Similarly with <tt>Shirt.red.dry_clean_only.average(:thread_count)</tt>.
      #
      # All \scopes are available as class methods on the ActiveRecord::Base descendant upon which the \scopes were defined. But they are also available to
      # <tt>has_many</tt> associations. If,
      #
      #   class Person < ActiveRecord::Base
      #     has_many :shirts
      #   end
      #
      # then <tt>elton.shirts.red.dry_clean_only</tt> will return all of Elton's red, dry clean
      # only shirts.
      #
      # Named \scopes can also be procedural:
      #
      #   class Shirt < ActiveRecord::Base
      #     named_scope :colored, lambda { |color|
      #       { :conditions => { :color => color } }
      #     }
      #   end
      #
      # In this example, <tt>Shirt.colored('puce')</tt> finds all puce shirts.
      #
      # Named \scopes can also have extensions, just as with <tt>has_many</tt> declarations:
      #
      #   class Shirt < ActiveRecord::Base
      #     named_scope :red, :conditions => {:color => 'red'} do
      #       def dom_id
      #         'red_shirts'
      #       end
      #     end
      #   end
      #
      #
      # For testing complex named \scopes, you can examine the scoping options using the
      # <tt>proxy_options</tt> method on the proxy itself.
      #
      #   class Shirt < ActiveRecord::Base
      #     named_scope :colored, lambda { |color|
      #       { :conditions => { :color => color } }
      #     }
      #   end
      #
      #   expected_options = { :conditions => { :colored => 'red' } }
      #   assert_equal expected_options, Shirt.colored('red').proxy_options
      def named_sql(name, options = {}, &block)
        name = name.to_sym

        scopes[name] = lambda do |parent_scope, *args|
          Scope.new(parent_scope, case options
            when Hash
              options
            when Proc
              if self.model_name != parent_scope.model_name
                options.bind(parent_scope).call(*args)
              else
                options.call(*args)
              end
            end, &block)
        end

        singleton_class.send :define_method, name do |*args|
          scopes[name].call(self, *args)
        end
      end
    end

    class Scope
      attr_reader :proxy_scope, :proxy_options, :current_scoped_methods_when_defined
      NON_DELEGATE_METHODS = %w(nil? send object_id class extend find size count sum average maximum minimum paginate first last empty? any? respond_to?).to_set
      [].methods.each do |m|
        unless m =~ /^__/ || NON_DELEGATE_METHODS.include?(m.to_s)
          delegate m, :to => :proxy_found
        end
      end

      delegate :scopes, :with_scope, :scoped_methods, :to => :proxy_scope

      def initialize(proxy_scope, options, &block)
        options ||= {}
        [options[:extend]].flatten.each { |extension| extend extension } if options[:extend]
        extend Module.new(&block) if block_given?
        unless (Scope === proxy_scope || ActiveRecord::Associations::AssociationCollection === proxy_scope)
          @current_scoped_methods_when_defined = proxy_scope.send(:current_scoped_methods)
        end
        @proxy_scope, @proxy_options = proxy_scope, options.except(:extend)
      end

      def reload
        load_found; self
      end

      def first(*args)
        if args.first.kind_of?(Integer) || (@found && !args.first.kind_of?(Hash))
          proxy_found.first(*args)
        else
          find(:first, *args)
        end
      end

      def last(*args)
        if args.first.kind_of?(Integer) || (@found && !args.first.kind_of?(Hash))
          proxy_found.last(*args)
        else
          find(:last, *args)
        end
      end

      def all(*args)
        proxy_found
      end
      
      def size
        @found ? @found.length : count
      end

      def empty?
        @found ? @found.empty? : count.zero?
      end

      def respond_to?(method, include_private = false)
        super || @proxy_scope.respond_to?(method, include_private)
      end

      def any?
        if block_given?
          proxy_found.any? { |*block_args| yield(*block_args) }
        else
          !empty?
        end
      end

      protected
      def proxy_found
        @found || load_found
      end

      private
      def method_missing(method, *args, &block)
        if scopes.include?(method)
          scopes[method].call(self, *args)
        else
          with_scope({:find => proxy_options, :create => proxy_options[:conditions].is_a?(Hash) ?  proxy_options[:conditions] : {}}, :reverse_merge) do
            method = :new if method == :build
            if current_scoped_methods_when_defined && !scoped_methods.include?(current_scoped_methods_when_defined)
              with_scope current_scoped_methods_when_defined do
                proxy_scope.send(method, *args, &block)
              end
            else
              proxy_scope.send(method, *args, &block)
            end
          end
        end
      end

      def load_found
        puts @proxy_options[:scope_sql]
        if @proxy_options[:scope_sql]
          puts "sql"
          @found = find_by_sql(@proxy_options[:scope_sql])
        elsif
          @found = find(:all)
        end
      end
    end
  end
end