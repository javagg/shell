class Contract <  ActiveRecord::Base
  acts_as_document
  has_many :payments
end
