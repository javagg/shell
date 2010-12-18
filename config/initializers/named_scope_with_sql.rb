#module ActiveRecord
#  module NamedScope
#
#
#    class Scope
#
#      def first(*args)
#
#        if args.first.kind_of?(Integer) || (@found && !args.first.kind_of?(Hash))
#          proxy_found.first(*args)
#        else
#          find(:first, *args)
#        end
#      end
#
#      def all(*args)
#        load_found
#      end
#
#      def last(*args)
#        if args.first.kind_of?(Integer) || (@found && !args.first.kind_of?(Hash))
#          proxy_found.last(*args)
#        else
#          find(:last, *args)
#        end
#      end
#
#      def size
#        puts "size"
##        puts @found.length
#        @found ? @found.length : count
#      end
#
#      def empty?
#        @found ? @found.empty? : count.zero?
#      end
#
#      def respond_to?(method, include_private = false)
#        super || @proxy_scope.respond_to?(method, include_private)
#      end
#
#      protected
#      def proxy_found
#        @found || load_found
#      end
#
#      private
#
#      def load_found
#        puts @proxy_options[:scope_sql]
#        if @proxy_options[:scope_sql]
#          puts "sql"
#          @found = find_by_sql(@proxy_options[:scope_sql])
#        elsif
#          @found = find(:all)
#        end
#      end
#    end
#  end
#end