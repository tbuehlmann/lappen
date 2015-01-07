require 'lappen/filter'
require 'lappen/filter_stack'
require 'lappen/filters'
require 'lappen/railtie'
require 'lappen/scope'
require 'lappen/request_context'
require 'lappen/request_context/hooks'
require 'lappen/version'

module Lappen
  class << self
    def setup_action_controller(base)
      base.send(:include, Lappen::RequestContext::Hooks)
    end

    def setup_active_record(base)
      base.send(:extend, Lappen::Scope)
    end
  end
end
