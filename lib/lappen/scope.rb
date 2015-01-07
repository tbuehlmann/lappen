module Lappen
  module Scope
    def lappen(params = {})
      stack = Lappen::FilterStack.find(self)
      stack.perform(self, params)
    end
  end
end
