module Shell
  include I18n
  DEPARTMENT_OPTIONS = %w(FN OP HR EN HSSE).map(&:to_sym)
  SHIFOU_OPTIONS = { I18n.t('txt.shi') => true, I18n.t('txt.fou') => false }
  CONFIDENTIAL_LEVEL = %w(#{I18n.t('txt.first_level')} OP HR EN HSSE).map(&:to_sym)
  DOCUMENT_STATUS = %w(FN OP HR EN HSSE).map(&:to_sym)
end