module Lappen
  module Filters
    class Pundit < Filter
      def perform(scope, params = {})
        resolved_policy_scope = resolved_policy_scope(scope)

        if resolved_policy_scope
          stack.perform(resolved_policy_scope, params)
        else
          stack.perform(scope, params)
        end
      end

      private

      def resolved_policy_scope(scope)
        policy_scope = ::Pundit::PolicyFinder.new(scope).scope

        if policy_scope
          policy_scope.new(pundit_user, scope).resolve
        else
          nil
        end
      end

      def pundit_user
        view_context.pundit_user
      end
    end
  end
end
