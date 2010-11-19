module SettingsHelper
  def setting_description_form_column(record, options)
    text_area :record, :description, options.merge({ :cols => 80, :rows => 5, :disabled => "disabled", :style => "background:#ffffff"})
  end
end
