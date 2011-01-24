module Shell
  module Options
    def self.department_options
      ["FN", "OP", "EN", "HR", "HSSE", "ND", "PR", "SUP", "GM"]
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
      [ I18n.t('txt.station_contract'), I18n.t('txt.purchase_contract'),
        I18n.t('txt.order_contract'), I18n.t('txt.order_contract1'),
        I18n.t('txt.order_contract2'), I18n.t('txt.order_contract3'),
        I18n.t('txt.order_contract4'), I18n.t('txt.order_contract6'),
        I18n.t('txt.framework_contract')
      ].map(&:to_sym)
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
          
        before_create :set_creator
        after_create :add_permissions

        named_scope :readable_by_user, lambda { |user| {
            :select=> "DISTINCT #{models}.*",
            :joins => "INNER JOIN #{permissions} ON #{permissions}.#{model}_id = #{models}.id " +
              "INNER JOIN user_ycroles ON #{permissions}.ycrole_id = user_ycroles.ycrole_id ",
            :conditions => "(#{permissions}.can_read = true OR #{permissions}.can_write = true) and user_ycroles.user_id = #{user.id}",
          }
        }


        named_scope :created_by_user, lambda { |user| {
            :conditions => ["user_id = ? ", user.id],
          }
        }

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

        return true if found

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
          if self.creator.username == role.name
            can_read = can_write = true
          elsif
            can_read = can_write = false
          end
          permissions.create doc_id => self.id, :ycrole_id => role.id,
            :can_read => can_read, :can_write => can_write
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

        unless creator.nil?
          self.creator = creator
          return true
        end
      end
      
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
        # add this for admin to set its read_write permissions,
        # admin can see all items in permission_batch_set lists
        # very important!!!!!!
        return true if current_user.username == "admin"

        return can_read_by_user?(current_user)
      end

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
        after_create :add_creator_as_expiration_remindee
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
      def add_creator_as_expiration_remindee
        remindee = current_user
        unless remindee.nil?
          ExpirationReminding.create(:user => remindee, :reminder => self)
        end
      end
      
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

  module YcroleDocumentControllerConfiguration
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
        
        def ycrole_model_name
          self.class.to_s.gsub(/Ycrole/, "").gsub(/Controller/,"").singularize
        end

        def permissions_name
          "#{ycrole_model_name}Permission"
        end
      end
    end

    module ClassMethods
      def config_active_scaffold(config)
        config.list.columns = [:number, :name]
        config.list.mark_records = true
        config.actions.exclude :create
        config.actions.exclude :update
        config.actions.exclude :show
        config.actions.exclude :delete

        config.actions.exclude :search
        config.actions << :field_search
        config.list.mark_records = true
        config.action_links.add :batch_set, :label => I18n.t('txt.batch_set')
        config.action_links[:batch_set].type = :collection

        config.field_search.link.label = I18n.t('txt.filter')
      end
    end
    
    module InstanceMethods
      def batch_set
        @selected_ids = marked_records.to_a
        @selecteds = ycrole_model_name.constantize.find @selected_ids
        render :template => "app/views/ycroles/batch_set.erb"
      end

      def batch_set_permissions
        role = Ycrole.find_by_name params[:ycrole]
        selected_ids = params[:selected_ids].split(",")
        selected = ycrole_model_name.constantize.find selected_ids
        model_id_sym = "#{ycrole_model_name.downcase.singularize}_id".to_sym
        selected.each do |select|
          permission = permissions_name.constantize.find(:first, :conditions => {:ycrole_id => role.id, model_id_sym => select.id })
          if permission
            if params[:read_write_action] == "all_not_read_write"
              permission.can_read = false
              permission.can_write = false
            elsif params[:read_write_action] == "all_read"
              permission.can_read = true
              permission.can_write = false
            elsif params[:read_write_action] == "all_write"
              permission.can_read = true
              permission.can_write = true
            end
            permission.save
          end
        end
        redirect_to :action => :index
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

  module PermissionsActiveScaffoldConfiguration
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    module ClassMethods
      def before_active_scaffold(doc)
        permissions = "#{doc.to_s}_permissions".to_sym
        in_place_edit_for permissions, :can_read
        in_place_edit_for permissions, :can_write
      end

      def config_active_scaffold(config, doc)
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
        config.create.link = false
        config.update.link = false
        config.delete.link = false

        config.action_links.add :batch_set, :label => I18n.t('txt.batch_set')
        config.action_links[:batch_set].type = :collection
        config.action_links[:batch_set].popup = true
        #        config.action_links[:download].security_method = :download_authorized?
      end
    end

    module InstanceMethods
      def batch_set
        redirect_to batch_permissions_path
      end
    end
  end

  module ImportExportExcel
    require 'spreadsheet'
    require 'iconv'

    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def header_field
        return {}
      end
      
      def parse(file)
        headers = header_field.keys

        sheet_index = 0
        encoding = 'utf-8'

        header_row = 0
        start_row = 1
        start_col = 0
        data = []

        workbook = Spreadsheet.open(file)
        unless(encoding.length > 0)
          Spreadsheet.client_encoding = encoding[0]
        end

        sheet = workbook.worksheet sheet_index
        if sheet
          cols_count = sheet.column_count
          rows_count = sheet.row_count

          ignore_cols = []
          field_index = {}
          end_col = start_col + cols_count
          (start_col...end_col).each do |col|
            header =  sheet.row(header_row)[col]
            if headers.include?(header)
              field_index[col] = header_field[header]
            else
              ignore_cols << col
            end
          end

          end_row = rows_count + start_col
          (start_row..end_row).each do |row|
            row_data = {}
            (start_col...end_col).each do |col|
              unless ignore_cols.include?(col)
                key = field_index[col].to_sym
                value = sheet.row(row)[col]
                row_data[key] = value
              end
            end
            data << row_data
          end
        end
        return data
      end

      def to_xls(ids = {})
        header_row = 0
        start_row = header_row + 1
        filename = "#{RAILS_ROOT}/tmp/export.xls"
        if File.exist?(filename)
          File.delete(filename)
        end
        
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet :name => "export objects"
        sheet.row(header_row).concat header_field.keys

        fields = header_field.values
        row = start_row
        ids.each do |id|
          record = self.find id
          values = []
          fields.each do |field|
            values << record[field]
          end
          sheet.insert_row row, values
          row += 1
        end
        book.write filename
        return filename
      end
    end
  end

  module ControllerWithCommonFunctions
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    module ClassMethods
      def config_active_scaffold(config)
        config.list.mark_records = true
        config.action_links.add :export, :label => I18n.t('txt.export'), :type => :collection, :popup => true
        config.action_links.add :upload_xls_file, :label => I18n.t('txt.import'), :type => :collection
        config.action_links.add :delete_marked, :label => I18n.t('txt.batch_delete'), :type => :collection, :inline => false
      end
    end
    
    module InstanceMethods
      def upload_xls_file
        render :partial => "app/views/upload/upload_xls_file.erb"
      end
      
      def delete_marked
        marked_records.each do |record_id|
          select = klass.find record_id
          if select and select.can_write_by_user?(current_user)
            klass.destroy record_id
            marked_records.delete record_id
          end
        end
        return_to_main
      end

      def import
        file = params[:upload][:xlsfile]
        if !file.original_filename.empty?
          filename = "#{RAILS_ROOT}/tmp/#{file.original_filename}"
          File.open(filename, "wb") do |f|
            f.write(file.read)
          end
          data = klass.parse(filename)
          klass.create data
          File.delete(filename)
          
          return_to_main
        end
      end

      def export
        filename = klass.to_xls marked_records
        send_file filename, :type => "application/xls"
      end

      private

      def klass
        model_name = self.controller_name.downcase.singularize.capitalize
        model_name.constantize
      end
    end
  end
end