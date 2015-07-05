require 'active_support/inflector'

module Lappen
  class FilterStack
    class << self
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
        new(scope, params).perform
      end

      def inherited(subclass)
        subclass.filters.concat(filters.dup)
      end
    end

    attr_accessor :scope, :params, :current_filter

    def initialize(scope, params = {})
      self.scope  = scope
      self.params = params
    end

    def perform
      catch(:halt) do
        self.class.filters.each do |triplet|
          self.current_filter = instantiate_filter(triplet)
          self.scope = perform_filter
        end

        scope
      end
    end

    private

    def perform_filter
      current_filter.perform(scope, params)
    end

    def instantiate_filter(triplet)
      filter_class, args, options = triplet
      filter_class.new(*args, **options)
    end
  end
end
