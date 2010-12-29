class Archive < ActiveRecord::Base
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
      "编号" => "number",
      "类型" => "archive_type",
      "名称" => "name",
      "发布部门" => "issue_dep",
      "保管部门" => "keep_dep",
      "保管人" => "keeper",
      "原件保存地址" => "original_loc",
      "有效期至" => "expired_on",
      "状态" => "state",
      "是否有备份" => "has_backup",
      "备份保存地址" => "backup_loc",
      "有电子版或需要电子版" => "has_electrical_edtion",
      "安全保密等级" => "confidential_level"
    }
  end
end




# == Schema Information
#
# Table name: archives
#
#  id                    :integer(4)      not null, primary key
#  number                :string(255)
#  name                  :string(255)
#  description           :text
#  archive_type          :string(255)
#  issue_dep             :string(255)
#  keep_dep              :string(255)
#  keeper                :string(255)
#  original_loc          :string(255)
#  expired_on            :date
#  state                 :string(255)
#  has_backup            :boolean(1)      default(FALSE)
#  backup_loc            :string(255)
#  has_electrical_edtion :boolean(1)      default(FALSE)
#  confidential_level    :string(255)
#  user_id               :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

