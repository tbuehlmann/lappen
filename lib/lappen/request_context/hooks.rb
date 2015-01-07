require 'active_support/concern'

module Lappen
  module RequestContext
    module Hooks
      extend ActiveSupport::Concern

      included do
        before_action :memoize_context
      end

      private

      def memoize_context
        Lappen::RequestContext.controller   = self
        Lappen::RequestContext.view_context = view_context
      end
    end
  end
end
