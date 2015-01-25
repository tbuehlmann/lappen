module Lappen
  module Filters
    class AssociationEmbedder < Filter
      def perform(scope, params = {})
        associations = associations(params)

        if associations.any?
          includer = AssociationIncluder.new(stack, *associations)
          includer.perform(scope)
        else
          stack.perform(scope)
        end
      end

      private

      def associations(params)
        @associations ||= begin
          association_params = params[include_key]

          association_array = case association_params
          when String
            association_params.split(delimiter)
          when Array
            association_params
          else
            []
          end

          association_array.select do |assoc|
            valid_association?(assoc)
          end
        end
      end

      def include_key
        options[:include_key] || :include
      end

      def delimiter
        options[:delimiter] || ','
      end

      def valid_association?(association)
        args.any? { |assoc| assoc.to_s == association}
      end
    end
  end
end
