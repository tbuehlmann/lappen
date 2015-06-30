module Lappen
  module Filters
    class Exactly < Filter
      def perform(scope, params = {})
        filter_arguments = filter_arguments(params)

        if filter_arguments.any?
          scope.where(filter_arguments.to_hash)
        else
          scope
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
