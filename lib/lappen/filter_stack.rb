require 'active_support/callbacks'
require 'active_support/inflector'

module Lappen
  class FilterStack
    include ActiveSupport::Callbacks
    define_callbacks :perform, :filter

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
      run_callbacks(:perform) do
        catch(:halt) do
          self.class.filters.each do |triplet|
            self.scope = perform_filter(triplet)
          end

          scope
        end
      end
    end

    private

    def perform_filter(triplet)
      self.current_filter = instantiate_filter(triplet)

      run_callbacks(:filter) do
        current_filter.perform(scope, params)
      end
    end

    def instantiate_filter(triplet)
      filter_class, args, options = triplet
      filter_class.new(*args, **options)
    end
  end
end
