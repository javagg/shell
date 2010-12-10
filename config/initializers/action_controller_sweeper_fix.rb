module ActionController
  module Caching
    class Sweeper < ActiveRecord::Observer
      attr_accessor :controller
      def before(controller)
        @controller_stack ||= []
        @controller_stack << controller
        self.controller = controller
        callback(:before) if controller.perform_caching
      end

      def after(controller)
        callback(:after) if controller.perform_caching
        @controller_stack.pop
        self.controller = @controller_stack.last
      end
    end
  end
end