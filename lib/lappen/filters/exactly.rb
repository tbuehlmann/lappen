module Lappen
  module Filters
    class Exactly < Filter
      PERMITTED_TYPES = [
        String,
        Symbol,
        NilClass,
        Numeric,
        TrueClass,
        FalseClass,
        Date,
        Time
      ]

      def perform(scope, params = {})
        filter_arguments = filter_arguments(params)
        add_meta_information(filter_arguments)

        if filter_arguments.any?
          scope.where(filter_arguments.to_hash)
        else
          scope
        end
      end

      private

      def filter_arguments(params)
        filterables = params.slice(*filterable_attributes)
        filterables.select { |_attribute, value| permitted_value?(value) }
      end

      def filterable_attributes
        args.flatten.uniq.map(&:to_s)
      end

      def permitted_value?(value)
        permitted_type?(value) || array_of_permitted_types?(value)
      end

      def permitted_type?(value)
        PERMITTED_TYPES.any? { |type| value.kind_of?(type) }
      end

      def array_of_permitted_types?(value)
        value.kind_of?(Array) && value.all? { |element| permitted_value?(element) }
      end

      def add_meta_information(filter_arguments)
        meta[:exactly] ||= {}
        meta[:exactly].merge!(filter_arguments.symbolize_keys)
      end
    end
  end
end
