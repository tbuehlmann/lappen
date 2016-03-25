require 'lappen/meta'
require 'active_support/core_ext/hash/indifferent_access'

module Lappen
  class Performer
    class << self
      def perform(filters, scope, params)
        new(filters, scope, params).perform
      end
    end

    def initialize(filters, scope, params)
      @filters = filters
      @scope   = scope
      @params  = params.with_indifferent_access
      @meta    = {}.with_indifferent_access
    end

    def perform
      decorate_scope(filtered_scope)
    end

    private

    def filtered_scope
      catch(:halt) do
        @filters.each do |triplet|
          filter = filter_for_triplet(triplet)
          @scope = filter.perform(@scope, @params)
        end

        @scope
      end
    end

    def decorate_scope(scope)
      scope.tap do |object|
        object.extend(Meta)
        object.meta = @meta
      end
    end

    def filter_for_triplet(triplet)
      klass, args, options = triplet
      klass.new(*args, **options.merge(meta: @meta))
    end
  end
end
