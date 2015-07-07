module Lappen
  module Filters
    class Comparable < Filter
      def perform(scope, params = {})
        comparables = comparables_for(params)
        conditions = conditions_for(comparables, scope)
        add_meta_information(comparables)

        conditions.each do |condition|
          scope = scope.where(condition)
        end

        scope
      end

      private

      def comparables_for(params)
        params.each_with_object(min: {}, max: {}) do |(key, value), comparables|
          attribute, extreme = attribute_and_extreme_for(key)

          if valid_extreme?(extreme) && comparable_attribute?(attribute)
            comparables[extreme.to_sym][attribute.to_sym] = parse_value(value)
          end
        end
      end

      def conditions_for(comparables, scope)
        comparables.each_with_object([]) do |(extreme, pairs), conditions|
          pairs.each do |attribute, value|
            arel_attribute = scope.klass.arel_table[attribute]
            conditions << condition_for(extreme, arel_attribute, value)
          end
        end
      end

      def condition_for(extreme, arel_attribute, value)
        case extreme
        when :min
          arel_attribute.gteq(value)
        when :max
          arel_attribute.lteq(value)
        end
      end

      def attribute_and_extreme_for(key)
        key.to_s.split(/_(min|max)\z/)
      end

      def valid_extreme?(extreme)
        ['min', 'max'].include?(extreme)
      end

      def parse_value(value)
        parser ? parser.parse(value) : value
      end

      def parser
        options[:parser]
      end

      def comparable_attribute?(attribute)
        comparable_attributes.include?(attribute)
      end

      def comparable_attributes
        @comparable_attributes ||= args.flatten.map(&:to_s).uniq
      end

      def add_meta_information(comparables)
        meta[:comparable] ||= {}
        meta[:comparable].merge!(comparables)
      end
    end
  end
end
