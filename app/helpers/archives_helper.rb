module ArchivesHelper
  def archive_has_electrical_edtion_column(record)
    record.has_electrical_edtion ? "是" : "否"
  end

  def archive_has_electrical_edtion_form_column(record, input_name)
    check_box record, :has_electrical_edtion, :name => input_name
  end

  def archive_has_backup_column(record)
    record.has_backup ? "是" : "否"
  end
  
  def archive_has_backup_form_column(record, input_name)
    check_box record, :has_backup, :name => input_name
  end
end
