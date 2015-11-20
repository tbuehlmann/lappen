require 'lappen/callbacks'
require 'active_support/notifications'

module Lappen
  module Notifications
    class << self
      def included(base)
        base.__send__(:include, Lappen::Callbacks)

        if base < Lappen::Pipeline
          add_around_perform_callback(base, type: :pipeline)
        elsif base < Lappen::Filter
          add_around_perform_callback(base, type: :filter)
        else
          raise 'Lappen::Notifications could not be included, the base class has to be of kind Lappen::Pipeline or Lappen::Filter'
        end
      end

      private

      def add_around_perform_callback(base, type: :pipeline)
        base.around_perform do |object, block|
          ActiveSupport::Notifications.instrument("lappen.#{type}.perform", type => object) do
            block.call
          end
        end
      end
    end
  end
end
