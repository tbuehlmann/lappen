require 'lappen/callbacks'
require 'active_support/notifications'

module Lappen
  module Notifications
    def self.included(base)
      base.__send__(:include, Lappen::Callbacks)

      base.around_perform do |filter_stack, block|
        ActiveSupport::Notifications.instrument('lappen.perform', filter_stack: filter_stack) do
          block.call
        end
      end

      base.around_filter do |filter_stack, block|
        ActiveSupport::Notifications.instrument('lappen.filter', filter_stack: filter_stack, filter: filter_stack.current_filter) do
          block.call
        end
      end
    end
  end
end
