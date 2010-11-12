
class Contract <  ActiveRecord::Base
  #acts_as_document
  has_many :payments, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  
end


# == Schema Information
#
# Table name: contracts
#
#  id                :integer(4)      not null, primary key
#  number            :string(255)
#  name              :string(255)
#  description       :text
#  contract_type     :string(255)
#  other_party       :string(255)
#  content           :text
#  start_date        :date
#  end_date          :date
#  expense_paid      :string(255)
#  owning_department :string(255)
#  amount            :integer(4)
#  person_in_charge  :string(255)
#  executive         :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

