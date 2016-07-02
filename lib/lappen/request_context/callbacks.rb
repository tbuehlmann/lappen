require 'active_support/concern'

module Lappen
  module RequestContext
    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_action :lappen_memoize_context
      end

      private

      def lappen_memoize_context
        Lappen::RequestContext.controller   = self
        Lappen::RequestContext.view_context = view_context
      end
    end
  end
end
