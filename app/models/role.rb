class Role < ActiveRecord::Base
  def to_label
    "#{name}"
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :users
end


# == Schema Information
#
# Table name: roles
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)     not null
#  description :string(255)
#

