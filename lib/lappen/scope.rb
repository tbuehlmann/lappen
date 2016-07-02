require 'lappen'
require 'rails/railtie'

module Lappen
  module Scope
    def pipeline(params = {})
      pipeline = Lappen::Pipeline.find(self)
      pipeline.perform(self, params)
    end
  end

  class Railtie < Rails::Railtie
    initializer 'lappen.setup_active_record' do |app|
      ActiveSupport.on_load(:active_record) do
        begin
          ::ApplicationRecord.extend(Lappen::Scope)
        rescue NameError
          extend Lappen::Scope
        end
      end
    end
  end
end
