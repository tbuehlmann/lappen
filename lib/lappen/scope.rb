module Lappen
  module Scope
    def lappen(params = {})
      pipeline = Lappen::Pipeline.find(self)
      pipeline.perform(self, params)
    end
  end
end
