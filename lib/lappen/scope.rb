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
    config.to_prepare do
      begin
        ApplicationRecord.extend(Lappen::Scope)
      rescue NameError
        ActiveRecord::Base.extend(Lappen::Scope)
      end
    end
  end
end
