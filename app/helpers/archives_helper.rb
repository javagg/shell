module ArchivesHelper
  def list_row_class(record)
    if record.respond_to? :expired?
      record.expired? ? 'expired' : 'not_expired'
    end
  end
end
