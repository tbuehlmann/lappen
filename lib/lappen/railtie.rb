require 'rails/railtie'

module Lappen
  class Railtie < Rails::Railtie
    initializer 'lappen.setup_action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Lappen::RequestContext::Hooks
      end
    end

    initializer 'lappen.setup_active_record' do |app|
      ActiveSupport.on_load(:active_record) do
        extend Lappen::Scope
      end
    end
  end
end
