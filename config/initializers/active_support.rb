ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :brdate => "%Y-%m-%d"
)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :brtime => "%p%I:%M"
)