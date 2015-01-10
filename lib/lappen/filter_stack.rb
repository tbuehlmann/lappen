require 'active_support/inflector'

module Lappen
  class FilterStack
    class << self
      attr_writer :filters

      def find(klass)
        if klass.respond_to?(:filter_stack_class)
          klass.filter_stack_class
        else
          "#{klass}FilterStack".constantize
        end
      end

      def use(filter, *args)
        filters << [filter, args]
      end

      def filters
        @filters ||= []
      end

      def perform(scope, params = {})
        new.perform(scope, params)
      end

      def inherited(subclass)
        subclass.filters = filters.dup
      end
    end

    def perform(scope, params = {})
      filter_class, args = enumerator.next
      filter = filter_class.new(self, *args)
      filter.perform(scope, params)
    rescue StopIteration
      scope
    end

    private

    def enumerator
      @enumerator ||= self.class.filters.to_enum
    end
  end
end
