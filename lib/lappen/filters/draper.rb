module Lappen
  module Filters
    class Draper < Filter
      def perform(scope, params = {})
        scope.decorate
      end
    end
  end
end
