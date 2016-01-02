module Lappen
  module Filters
    class Kaminari < Filter
      def perform(scope, params = {})
        page =    params[page_key]
        per  =    params[per_key]
        padding = params[padding_key]
        paginated_scope = scope.public_send(page_method_name, page).per(per).padding(padding)

        add_meta_information(paginated_scope)
        paginated_scope
      end

      private

      def page_key
        options.fetch(:page_key, ::Kaminari.config.param_name)
      end

      def per_key
        options.fetch(:per_key, :per)
      end

      def padding_key
        options.fetch(:padding_key, :padding)
      end

      def page_method_name
        ::Kaminari.config.page_method_name
      end

      def add_meta_information(scope)
        meta[:pagination] ||= {}

        meta[:pagination].merge!(
          page: scope.current_page,
          per: scope.limit_value,
          padding: scope.instance_variable_get(:@_padding).to_i
        )
      end
    end
  end
end
