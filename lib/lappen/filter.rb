require 'lappen/request_context'

module Lappen
  class Filter
    include RequestContext

    attr_reader :args, :options

    def initialize(*args, **options)
      @args    = args
      @options = options
    end

    def perform(scope, params = {})
      scope
    end

    private

    def meta
      @meta ||= options[:meta]
    end
  end
end
