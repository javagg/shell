require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

