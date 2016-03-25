require 'lappen/performer'
require 'active_support/core_ext/hash/indifferent_access'
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

      def use(klass, *args, **options)
        filters << [klass, args, options]
      end

      def filters
        @filters ||= []
      end

      def perform(scope, params = {})
        new.perform(scope, params)
      end

      def inherited(subclass)
        subclass.filters.concat(filters.dup)
      end
    end

    def perform(scope, params = {})
      Performer.perform(self.class.filters, scope, params)
    end
  end
end
