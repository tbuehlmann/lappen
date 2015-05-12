module Lappen
  module Filters
    class Kaminari < Filter
      def perform(scope, params = {})
        page_key = options.fetch(:page_key, :page)
        per_key  = options.fetch(:per_key, :per)

        scope.page(params[page_key]).per(params[per_key])
      end
    end
  end
end
