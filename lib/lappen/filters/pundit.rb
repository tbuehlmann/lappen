module Lappen
  module Filters
    class Pundit < Filter
      def perform(scope, params = {})
        policy_scope(scope) || scope
      end

      private

      def policy_scope(scope)
        pundit_scope = ::Pundit::PolicyFinder.new(scope).scope
        pundit_scope.new(pundit_user, scope).resolve
      end

      def pundit_user
        view_context.pundit_user
      end
    end
  end
end
