class Archive < ActiveRecord::Base
  has_many :attachments, :as => :attachable, :dependent => :destroy
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
#  origin_loc            :string(255)
#  expired_at            :date
#  state                 :string(255)
#  has_backup            :boolean(1)
#  backup_loc            :string(255)
#  has_electrical_edtion :boolean(1)
#  security_level        :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

