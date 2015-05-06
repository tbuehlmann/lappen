require 'lappen/request_context'

module Lappen
  class Filter
    include RequestContext

    attr_reader :stack, :args, :options

    def initialize(stack, *args, **options)
      @stack   = stack
      @args    = args
      @options = options
    end

    def perform(scope, params = {})
      stack.perform(scope, params)
    end
  end
end
