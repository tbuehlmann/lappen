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

      def use(filter, *args, **options)
        filters << [filter, args, options]
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
      catch(:halt) do
        self.class.filters.each do |triplet|
          filter = instantiate_filter(triplet)
          scope = filter.perform(scope, params)
        end

        scope
      end
    end

    private

    def instantiate_filter(triplet)
      filter_class, args, options = triplet
      filter_class.new(self, *args, **options)
    end
  end
end
