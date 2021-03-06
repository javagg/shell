require 'date'

class Contract <  ActiveRecord::Base
  acts_as_audited :only => [:create, :update, :destroy]

  acts_as_expirable
  acts_as_attachable

  validates_presence_of :number
  validates_uniqueness_of :number

  has_many :payments, :dependent => :destroy
  has_many :payment_periods, :dependent => :destroy
  has_many :payment_remindings, :dependent => :destroy
  has_many :payment_remindees, :through => :payment_remindings, :source => 'user'

  include Shell::Authorized
  acts_as_authorized

  after_create :add_creator_as_payment_remindee
 
  def add_creator_as_payment_remindee
    remindee = current_user
    unless remindee.nil?
      PaymentReminding.create(:user => remindee, :contract => self)
    end
  end
      
  def next_payment_date(from = Date.today)
    payment_dates.find_all { |e| e > from }.min
  end
 
  def payment_dates
    dates = []
    payment_periods.each do |period|
      dates.concat period.payment_dates
    end
    dates.uniq.sort
  end

  def remind_payment
    payment_remindees.each do | remindee |
      Emailer.deliver_contract_payment_reminding self, remindee
    end
  end

  def self.check_payment
    all_contracts = self.find :all
    all_contracts.each do |contract|
      payment_date = contract.next_payment_date
      if payment_date and payment_date > Date.today and payment_date < payment_date + payment_reminding_days
        contract.remind_payment
      end
    end
  end
 
  def expired_on
    end_date
  end

  def self.expiration_reminding_days
    Settings.expiration_reminding_days.to_i
  end

  def self.payment_reminding_days
    Settings.payment_reminding_days.to_i
  end

  include Shell::ImportExportExcel

  def self.header_field
    return {
      "类型" => "contract_type",
      "印花税类型" => "stamp_tax_type",
      "合同编号" => "number",
      "合同名称" => "name",
      "项目地址" => "project_address",
      "交易模式" => "trading_mode",
      "土地证办理期限" => "land_certificate_application_deadline",
      "房产证办理期限" => "property_certificate_application_deadline",
      "合同对方" => "other_party",
      "合同内容" => "contract_content",
      "开始日期（租赁起始日）" => "start_date",
      "结束日期" => "end_date",
      "费用归属" => "expense_paid",
      "所属部门" => "owning_department",
      "合同金额" => "amount",
      "合同持有人" => "holder",
      "合同具体执行人" => "executive",
      "移交保管情况" => "transferred",
      "状态" => "state",
      "原件保存地址" => "original_loc",
      "是否有备份" => "has_backup",
      "备份保存地址" => "backup_loc",
      "安全保密等级" => "confidential_level",
    }
  end
end

# == Schema Information
#
# Table name: contracts
#
#  id                                        :integer(4)      not null, primary key
#  number                                    :string(255)
#  name                                      :string(255)
#  description                               :text
#  station_name                              :string(255)
#  stamp_tax_type                            :string(255)
#  contract_type                             :string(255)
#  project_address                           :string(255)
#  trading_mode                              :string(255)
#  land_certificate_application_deadline     :date
#  property_certificate_application_deadline :date
#  other_party                               :string(255)
#  contract_content                          :text
#  start_date                                :date
#  end_date                                  :date
#  expense_paid                              :string(255)
#  owning_department                         :string(255)
#  amount                                    :integer(10)
#  holder                                    :string(255)
#  executive                                 :string(255)
#  transferred                               :boolean(1)      default(FALSE)
#  state                                     :string(255)
#  original_loc                              :string(255)
#  has_backup                                :boolean(1)      default(FALSE)
#  backup_loc                                :string(255)
#  has_electrical_edtion                     :boolean(1)      default(FALSE)
#  confidential_level                        :string(255)
#  memo                                      :text
#  user_id                                   :integer(4)
#  created_at                                :datetime
#  updated_at                                :datetime
#

