module Lappen
  module Filters
    class Pundit < Filter
      def perform(scope, params = {})
        pundit_scope = pundit_scope(scope)

        if pundit_scope
          scoped_scope = pundit_scope.new(pundit_user, scope).resolve
          stack.perform(scoped_scope, params)
        else
          stack.perform(scope, params)
        end
      end

      private

      def pundit_scope(scope)
        @pundit_scope ||= ::Pundit::PolicyFinder.new(scope).scope
      end

      def pundit_user
        view_context.pundit_user
      end
    end
  end
end
