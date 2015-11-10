require 'lappen/callbacks'
require 'active_support/notifications'

module Lappen
  module Notifications
    def self.included(base)
      base.__send__(:include, Lappen::Callbacks)

      base.around_perform do |pipeline, block|
        ActiveSupport::Notifications.instrument('lappen.perform', pipeline: pipeline) do
          block.call
        end
      end

      base.around_filter do |pipeline, block|
        ActiveSupport::Notifications.instrument('lappen.filter', pipeline: pipeline, filter: pipeline.filter) do
          block.call
        end
      end
    end
  end
end
