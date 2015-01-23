module Lappen
  module Filters
    class Draper < Filter
      def perform(scope, params = {})
        decorated_scope = scope.decorate
        stack.perform(decorated_scope, params)
      end
    end
  end
end
