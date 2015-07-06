module Lappen
  module Filters
    class AssociationEmbedder < Filter
      def perform(scope, params = {})
        associations = associations_for(params)

        if associations.any?
          includer = AssociationIncluder.new(*associations, meta: meta)
          includer.perform(scope)
        else
          scope
        end
      end

      private

      def associations_for(params)
        association_params = params[include_key]

        associations = case association_params
        when String
          association_params.split(delimiter)
        when Array
          association_params.map(&:to_s)
        else
          []
        end

        associations.select do |association|
          valid_association?(association)
        end
      end

      def include_key
        options.fetch(:include_key, :include)
      end

      def delimiter
        options.fetch(:delimiter, ',')
      end

      def valid_association?(association)
        valid_associations.include?(association)
      end

      def valid_associations
        @valid_associations ||= args.flatten.map(&:to_s).uniq
      end
    end
  end
end
