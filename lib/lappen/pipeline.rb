require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector'

module Lappen
  class Pipeline
    class << self
      def find(klass)
        if klass.respond_to?(:pipeline_class)
          klass.pipeline_class
        else
          "#{klass}Pipeline".constantize
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

    attr_accessor :scope, :params, :filter

    def initialize(scope, params = {})
      self.scope  = scope
      self.params = ActiveSupport::HashWithIndifferentAccess.new_from_hash_copying_default(params)
    end

    def perform
      catch(:halt) do
        self.class.filters.each do |triplet|
          self.filter = instantiate_filter(triplet)
          self.scope = perform_filter
        end

        scope
      end
    end

    def meta
      @meta ||= {}
    end

    private

    def perform_filter
      filter.perform(scope, params)
    end

    def instantiate_filter(triplet)
      filter_class, args, options = triplet
      filter_class.new(*args, **options.merge(meta: meta))
    end
  end
end
