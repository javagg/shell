class Payment < ActiveRecord::Base
  belongs_to :contract
end
