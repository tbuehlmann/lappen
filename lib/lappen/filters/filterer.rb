module Lappen
  module Filters
    class Filterer < Filter
      def perform(scope, params = {})
        filter_arguments(params).each do |attribute, value|
          if value.kind_of?(String)
            scope = scope.public_send("with_#{attribute}", value)
          end
        end

        stack.perform(scope, params)
      end

      private

      def filter_arguments(params)
        params.slice(*filterable_attributes)
      end

      def filterable_attributes
        args.flatten.uniq.map(&:to_s)
      end
    end
  end
end
