module Shell
  include I18n
  DEPARTMENT_OPTIONS = %w(FN OP HR EN HSSE).map(&:to_sym)
  SHIFOU_OPTIONS = { I18n.t('txt.shi') => true, I18n.t('txt.fou') => false }
  CONFIDENTIAL_LEVEL_OPTIONS = [ I18n.t('txt.confidential_high'), I18n.t('txt.confidential_low')].map(&:to_sym)
  DOCUMENT_STATUS_OPTIONS = %w(FN OP HR EN HSSE).map(&:to_sym)
  STAMP_TAX_TYPE_OPTIONS = [ I18n.t('txt.buying_and_selling'), I18n.t('txt.lease'),
    I18n.t('txt.investigation'),  I18n.t('txt.construction_safety') ].map(&:to_sym)
 CONTRACT_TYPE_OPTIONS = [ I18n.t('txt.station_contract'), I18n.t('txt.purchase_contract') ].map(&:to_sym)
 TRADING_MODE_OPTIONS = [ I18n.t('txt.purchase'), I18n.t('txt.lease') ].map(&:to_sym)
end