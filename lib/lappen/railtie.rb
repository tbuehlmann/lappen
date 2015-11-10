require 'rails/railtie'

module Lappen
  class Railtie < Rails::Railtie
    initializer 'lappen.setup_action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Lappen::RequestContext::Hooks
      end
    end
  end
end
