require 'active_support/callbacks'

module Lappen
  module Callbacks
    def self.included(base)
      base.__send__(:include, ActiveSupport::Callbacks)
      base.__send__(:prepend, InstanceMethods)
      base.__send__(:extend,  ClassMethods)

      base.define_callbacks(:perform, :filter)
    end

    module InstanceMethods
      def perform(*)
        run_callbacks(:perform) { super }
      end

      def perform_filter(*)
        run_callbacks(:filter) { super }
      end
    end

    module ClassMethods
      [:perform, :filter].each do |action|
        [:before, :around, :after].each do |callback|
          define_method "#{callback}_#{action}" do |*names, &block|
            set_callback(action, callback, *names, &block)
          end
        end
      end
    end
  end
end
