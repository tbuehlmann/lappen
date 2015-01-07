require 'request_store'

# Idea from:
# # From: https://github.com/drapergem/draper/blob/724e735a0310bd29412749a4fdbed376db5d580f/lib/draper/view_context.rb
module Lappen
  module RequestContext
    class << self
      def controller=(controller)
        RequestStore.store[:lappen_controller] = controller
      end

      def view_context=(view_context)
        RequestStore.store[:lappen_view_context] = view_context
      end
    end

    module_function

    def controller
      RequestStore.store[:lappen_controller]
    end

    def view_context
      RequestStore.store[:lappen_view_context]
    end
  end
end
