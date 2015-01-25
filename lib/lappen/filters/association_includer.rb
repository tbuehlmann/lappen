module Lappen
  module Filters
    class AssociationIncluder < Filter
      def perform(scope, params = {})
        included_scope = scope.includes(args)
        stack.perform(included_scope, params)
      end
    end
  end
end
