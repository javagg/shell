class Contract <  ActiveRecord::Base
  #acts_as_document
  has_many :payments
  has_many :reminders
end
