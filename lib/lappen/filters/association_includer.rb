require 'set'

module Lappen
  module Filters
    class AssociationIncluder < Filter
      def perform(scope, params = {})
        add_meta_information(args)

        if args.any?
          scope.includes(args)
        else
          scope
        end
      end

      private

      def add_meta_information(associations)
        meta[:include] ||= Set.new
        meta[:include].merge(associations.map(&:to_sym))
      end
    end
  end
end
