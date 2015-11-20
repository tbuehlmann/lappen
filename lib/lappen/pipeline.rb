require 'lappen/meta'
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

    attr_reader :scope, :params

    def initialize(scope, params = {})
      @scope  = scope
      @params = ActiveSupport::HashWithIndifferentAccess.new_from_hash_copying_default(params)
    end

    def perform
      decorate_scope(filtered_scope)
    end

    private

    def filtered_scope
      scope = self.scope

      catch(:halt) do
        self.class.filters.each do |triplet|
          filter = instantiate_filter(triplet)
          scope = filter.perform(scope, params)
        end

        scope
      end
    end

    def decorate_scope(scope)
      scope.tap do |object|
        scope.extend(Meta)
        scope.meta = meta
      end
    end

    def instantiate_filter(triplet)
      filter, args, options = triplet
      filter.new(*args, **options.merge(meta: meta))
    end

    def meta
      @meta ||= {}
    end
  end
end
