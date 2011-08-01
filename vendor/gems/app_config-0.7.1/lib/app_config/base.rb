module AppConfig

  require 'uri'

  # The Base storage class.
  # Acts as a wrapper for the different storage methods.
  #
  # See each storage method's documentation for their specific options.
  #
  # Valid storage methods:
  # * :memory (AppConfig::Storage::Memory)
  # * :mongo (AppConfig::Storage::Mongo)
  # * :sqlite (AppConfig::Storage::Sqlite)
  # * :yaml (AppConfig::Storage::YAML)
  #
  # TODO: Purge AppConfig options (ie, those not related to the user-end).
  class Base

    # TODO: All these DEFAULTS constants are kinda annoying.
    DEFAULTS = {
      :storage_method => :memory,
    }

    # Accepts either a hash of +options+ or a block (which overrides
    # any options passed in the hash).
    def initialize(options = {}, &block)
      @options = DEFAULTS.merge(options)
      yield @options if block_given?

      determine_storage_method if @options[:uri]
      @storage_method = initialize_storage_method
      @storage = @storage_method.data
    end

    # Access the <tt>key</tt>'s value in storage.
    def [](key)
      if storage.respond_to?(:[])
        storage[key]
      else
        raise AppConfig::Error::MustOverride.new('#[]')
      end
    end

    def []=(key, value)
      if storage.respond_to?(:[]=)
        storage[key] = value
      else
        raise AppConfig::Error::MustOverride.new('#[]=')
      end
    end

    def empty?
      if storage.respond_to?(:empty?)
        storage.empty?
      else
        raise AppConfig::Error::MustOverride.new('#empty?')
      end
    end

    def environment
      (@options[:environment] || @options[:env]) || nil
    end
    alias_method :env, :environment

    # Returns the <tt>@storage</tt> contents, which is what is exposed
    # as the configuration.
    def storage
      environment ? @storage[environment] : @storage
    end

    def to_hash
      storage.to_hash
    end

    private

    # Sets the storage_method depending on the URI given.
    def determine_storage_method
      uri = URI.parse(@options.delete(:uri))
      case uri.scheme
      when 'sqlite'
        @options[:storage_method] = :sqlite
        @options[:database] = uri.path
      when 'yaml'
        @options[:storage_method] = :yaml
        @options[:path] = uri.path
      end
    end

    # This decides how to load the data, based on the +storage_method+.
    def initialize_storage_method
      @storage_method = case @options[:storage_method]
      when :memory
        AppConfig::Storage::Memory.new(@options)
      when :mongo
        AppConfig::Storage::Mongo.new(@options)
      when :sqlite
        AppConfig::Storage::Sqlite.new(@options)
      when :yaml
        AppConfig::Storage::YAML.new(@options)
      else
        raise AppConfig::Error::UnknownStorageMethod
      end
    end

  end # Base
end # AppConfig
