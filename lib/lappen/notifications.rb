require 'active_support/concern'
require 'active_support/notifications'

module Lappen
  module Notifications
    extend ActiveSupport::Concern

    included do
      set_callback(:perform, :around) do |filter_stack, block|
        ActiveSupport::Notifications.instrument('lappen.perform', filter_stack: filter_stack) do
          block.call
        end
      end

      set_callback(:filter, :around) do |filter_stack, block|
        ActiveSupport::Notifications.instrument('lappen.filter', filter_stack: filter_stack, filter: filter_stack.current_filter) do
          block.call
        end
      end
    end
  end
end
