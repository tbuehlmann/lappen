require 'active_support/hash_with_indifferent_access'

module Lappen
  module Filters
    class Comparable < Filter
      DEFAULT_PARSER = Object.new.tap do |parser|
        def parser.parse(value)
          value
        end
      end

      def perform(scope, params = {})
        populate_comparables!(params)
        add_meta_information

        minima.each do |attribute, value|
          arel_attribute = scope.klass.arel_table[attribute]
          scope = scope.where(arel_attribute.gteq(value))
        end

        maxima.each do |attribute, value|
          arel_attribute = scope.klass.arel_table[attribute]
          scope = scope.where(arel_attribute.lteq(value))
        end

        ranges.each do |attribute, range|
          scope = scope.where(attribute => range)
        end

        scope
      end

      private

      def populate_comparables!(params)
        params.each do |key, value|
          key = key.to_s

          if key.end_with?('_min')
            attribute = key[0..-5]

            if comparable_attribute?(attribute)
              memoize_minimum(attribute.to_sym, value)
            end
          elsif key.end_with?('_max')
            attribute = key[0..-5]

            if comparable_attribute?(attribute)
              memoize_maximum(attribute.to_sym, value)
            end
          end
        end
      end

      def memoize_minimum(attribute, value)
        parsed_value = parser.parse(value)

        if maximum_value = maxima.delete(attribute)
          ranges[attribute] = parsed_value..maximum_value
        else
          minima[attribute] = parsed_value
        end
      end

      def memoize_maximum(attribute, value)
        parsed_value = parser.parse(value)

        if minimum_value = minima.delete(attribute)
          ranges[attribute] = minimum_value..parsed_value
        else
          maxima[attribute] = parsed_value
        end
      end

      def minima
        @minima ||= {}
      end

      def maxima
        @maxima ||= {}
      end

      def ranges
        @ranges ||= {}
      end

      def parser
        @parser ||= options.fetch(:parser, DEFAULT_PARSER)
      end

      def comparable_attribute?(attribute)
        attribute.kind_of?(String) && comparable_attributes.include?(attribute)
      end

      def comparable_attributes
        @comparable_attributes ||= args.flatten.map(&:to_s).uniq
      end

      def add_meta_information
        min = minima.merge(Hash[ranges.map { |attribute, range| [attribute, range.min] }])
        max = maxima.merge(Hash[ranges.map { |attribute, range| [attribute, range.max] }])

        meta[:comparable] ||= {}
        meta[:comparable].merge!(minima: min, maxima: max)
      end
    end
  end
end
