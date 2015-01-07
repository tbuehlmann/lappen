require 'rails/railtie'

module Lappen
  class Railtie < Rails::Railtie
    initializer 'lappen.setup_action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        Lappen.setup_action_controller(self)
      end
    end

    initializer 'lappen.setup_active_record' do |app|
      ActiveSupport.on_load(:active_record) do
        Lappen.setup_active_record(self)
      end
    end
  end
end
