class PaymentsController < ApplicationController

  active_scaffold :payments do |config|
    config.columns = [ :amount, :pay_date, :has_deliverables, :memo ]
    config.columns[:pay_date].description = I18n.t('txt.pick_a_date')
    config.columns[:has_deliverables].form_ui = :select
    config.columns[:has_deliverables].options = { :options => Shell::Options::shifou_options }
    config.columns[:memo].form_ui = :textarea
    config.columns[:memo].options = { :rows => 4, :cols => 30 }
  end

  include Shell::CreationAuthorization
end
