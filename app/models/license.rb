class License <  ActiveRecord::Base
  acts_as_audited :only => [:create, :update, :destroy]

  acts_as_expirable
  acts_as_attachable

  include Shell::Authorized
  acts_as_authorized
  
  validates_presence_of :number
  validates_uniqueness_of :number

  def self.expiration_reminding_days
    Settings.expiration_reminding_days.to_i
  end

  include Shell::ImportExportExcel
  
  def self.header_field
    return {
      "T5代码" => "t5code",
      "区域" => "area",
      "油站名称" => "station_name",
      "证照名称" => "name",
      "编号或注册号" => "number",
      "发证机关" => "issuing_authority",
      "发证时间" => "issuing_date",
      "年审时间" => "annual_inspection_date",
      "有效期" => "expired_on",
      "存放地点" => "original_loc",
      "备注" => "memo",
      "所属部门" => "owning_department",
      "状态" => "state",
      "安全保密等级" => "confidential_level"
    }
  end
end


# == Schema Information
#
# Table name: licenses
#
#  id                     :integer(4)      not null, primary key
#  number                 :string(255)
#  name                   :string(255)
#  description            :text
#  t5code                 :string(255)
#  area                   :string(255)
#  station_name           :string(255)
#  issuing_authority      :string(255)
#  issuing_date           :date
#  state                  :string(255)
#  annual_inspection_date :date
#  expired_on             :date
#  original_loc           :string(255)
#  backup_loc             :string(255)
#  memo                   :text
#  owning_department      :string(255)
#  has_electrical_edtion  :boolean(1)      default(FALSE)
#  confidential_level     :string(255)
#  user_id                :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

