module Lappen
  module Filters
    class Equal < Filter
      PERMITTED_TYPES = [
        String,
        Symbol,
        NilClass,
        Numeric,
        TrueClass,
        FalseClass,
        Date,
        Time
      ].freeze

      def perform(scope, params = {})
        filters = filters(params)
        add_meta_information(filters)

        if filters.any?
          scope.where(filters.to_hash)
        else
          scope
        end
      end

      private

      def filters(params)
        filterables = filter_arguments(params).slice(*filterable_attributes)
        filterables.select { |_attribute, value| permitted_value?(value) }
      end

      def filter_arguments(params)
        filter_arguments = filter_key ? params[filter_key] : params

        if filter_arguments.respond_to?(:to_unsafe_hash)
          filter_arguments.to_unsafe_hash
        elsif filter_arguments.respond_to?(:to_hash)
          filter_arguments.to_hash
        else
          {}
        end
      end

      def filter_key
        @filter_key ||= options.fetch(:filter_key, :filter)
      end

      def filterable_attributes
        args.flatten.map(&:to_s).uniq
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

      def add_meta_information(filters)
        meta[:equal] ||= {}
        meta[:equal].merge!(filters.symbolize_keys)
      end
    end
  end
end
