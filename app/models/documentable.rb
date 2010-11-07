module Documentable
  def self.included(base)
    base.has_one :document, :as => :documentable, :autosave => true
    base.validate :document_must_be_valid
    base.alias_method_chain :document, :autobuild
    base.extend ClassMethods
    base.define_document_accessors
  end

  def document_with_autobuild
    document_without_autobuild || build_document
  end

  def method_missing(method, *args, &block)
    document.send(method, *args, &block)
  rescue NoMethodError
    super
  end

  module ClassMethods
    def define_document_accessors
      all_attributes = Document.content_columns.map(&:name)
      ignored_attributes = ["created_at", "updated_at", "documentable_type"]
      attributes_to_delegate = all_attributes - ignored_attributes
      attributes_to_delegate.each do |attrib|
        class_eval <<-RUBY
            def #{attrib}
              document.#{attrib}
            end

            def #{attrib}=(value)
              self.document.#{attrib} = value
            end

            def #{attrib}?
              self.document.#{attrib}?
            end
        RUBY
      end
    end
  end

  protected
  def document_must_be_valid
    unless document.valid?
      document.errors.each do |attr, message|
        errors.add(attr, message)
      end
    end
  end
end