require 'active_support/core_ext/array/extract_options'
require 'lappen/request_context'

module Lappen
  class Filter
    include RequestContext

    attr_reader :stack, :args, :options

    def initialize(stack, *args)
      @stack   = stack
      @args    = args
      @options = args.extract_options!
    end

    def perform(scope, params = {})
      stack.perform(scope, params)
    end
  end
end
