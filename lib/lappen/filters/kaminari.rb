module Lappen
  module Filters
    class Kaminari < Filter
      def perform(scope, params = {})
        page = params[page_key]
        per  = params[per_key]

        add_meta_information(page, per)
        scope.page(page).per(per)
      end

      private

      def page_key
        options.fetch(:page_key, 'page').to_s
      end

      def per_key
        options.fetch(:per_key, 'per').to_s
      end

      def add_meta_information(page, per)
        meta[:kaminari] ||= {}
        meta[:kaminari].merge!(page: page, per: per)
      end
    end
  end
end
