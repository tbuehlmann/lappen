module Lappen
  module Filters
    class Orderer < Filter
      def perform(scope, params = {})
        ordering = ordering(params)

        if ordering.any?
          reorder? ? scope.reorder(ordering) : scope.order(ordering)
        else
          scope
        end
      end

      private

      def ordering(params)
        @ordering ||= if params[order_key].kind_of?(String)
          params[order_key].split(order_delimiter).each_with_object({}) do |order, reorder_hash|
            attribute, direction = split_attribute_with_direction(order)
            reorder_hash[attribute] = direction if orderable?(attribute)
          end
        else
          {}
        end
      end

      def reorder?
        options.fetch(:reorder, false)
      end

      def order_key
        @order_key ||= options.fetch(:order_key, :order)
      end

      def order_delimiter
        @order_delimiter ||= options.fetch(:delimiter_key, ',')
      end

      def orderable?(attribute)
        args.any? { |orderable_attribute| orderable_attribute.to_s == attribute }
      end

      def split_attribute_with_direction(attribute_with_direction)
        if attribute_with_direction.start_with?('-')
          [attribute_with_direction[1..-1], :desc]
        else
          [attribute_with_direction, :asc]
        end
      end
    end
  end
end
