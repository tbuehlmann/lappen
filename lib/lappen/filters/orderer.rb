module Lappen
  module Filters
    class Orderer < Filter
      def perform(scope, params = {})
        ordering = ordering(params)
        add_meta_information(ordering)

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
            reorder_hash[attribute.to_sym] = direction if orderable?(attribute)
          end
        else
          {}
        end
      end

      def reorder?
        options.fetch(:reorder, false)
      end

      def order_key
        @order_key ||= options.fetch(:order_key, :order).to_s
      end

      def order_delimiter
        @order_delimiter ||= options.fetch(:delimiter_key, ',').to_s
      end

      def split_attribute_with_direction(attribute_with_direction)
        if attribute_with_direction.start_with?('-')
          [attribute_with_direction[1..-1], :desc]
        else
          [attribute_with_direction, :asc]
        end
      end

      def orderable?(attribute)
        orderable_attributes.include?(attribute)
      end

      def orderable_attributes
        @orderable_attributes ||= args.flatten.map(&:to_s).uniq
      end

      def add_meta_information(ordering)
        if reorder?
          meta[:ordering] = ordering
        else
          meta[:ordering] ||= {}
          meta[:ordering].merge!(ordering)
        end
      end
    end
  end
end
