module AppConfig
  module Storage
    class Memory < Storage::Base

      def initialize(options)
        super(options)
        @data = Hashish.new(options)
      end

    end # Memory
  end # Storage
end # AppConfig
