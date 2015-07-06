module Lappen
  module Filters
    class Pundit < Filter
      def perform(scope, params = {})
        pundit_policy_scope = ::Pundit::PolicyFinder.new(scope).scope!
        add_meta_information(pundit_policy_scope)

        pundit_policy_scope.new(pundit_user, scope).resolve
      end

      private

      def pundit_user
        view_context.pundit_user
      end

      def add_meta_information(pundit_policy_scope)
        meta[:pundit] ||= []

        if pundit_policy_scope
          meta[:pundit] << pundit_policy_scope
        end
      end
    end
  end
end
