module Lappen
  module Filters
    class ExactFilter < Filter
      def perform(scope, params = {})
        filter_arguments = filter_arguments(params)

        if filter_arguments.any?
          filtered_scope = scope.where(filter_arguments)
          stack.perform(filtered_scope, params)
        else
          stack.perform(scope, params)
        end
      end

      private

      def filter_arguments(params)
        filterables = params.slice(*filterable_attributes)
        filterables.select { |_attribute, value| value.kind_of?(String) }
      end

      def filterable_attributes
        args.flatten.uniq.map(&:to_s)
      end
    end
  end
end
