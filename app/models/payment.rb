class Payment < ActiveRecord::Base
  belongs_to :contracts
end
