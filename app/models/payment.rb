class Payment < ActiveRecord::Base
  def to_label

  end

  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  belongs_to :contract

  include Shell::HasParentAssociation
  parent_association :contract
end

# == Schema Information
#
# Table name: payments
#
#  id               :integer(4)      not null, primary key
#  contract_id      :integer(4)
#  pay_date         :date
#  amount           :integer(10)
#  has_deliverables :boolean(1)      default(FALSE)
#  memo             :text
#  created_at       :datetime
#  updated_at       :datetime
#

