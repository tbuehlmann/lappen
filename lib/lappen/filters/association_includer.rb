module Lappen
  module Filters
    class AssociationIncluder < Filter
      def perform(scope, params = {})
        if args.any?
          scope.includes(args)
        else
          scope
        end
      end
    end
  end
end
