I18n.default_locale = 'zh'

if RAILS_ENV == "test"
  I18n.default_locale = 'en'
end

LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales/"
LOCALES_AVAILABLE = {
  'English' => :en,
  '简体中文' => :zh
}
