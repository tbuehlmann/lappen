require 'spec_helper'
require 'action_controller'

describe Lappen::RequestContext::Hooks do
  let(:controller_class) { Class.new(ActionController::Base) }
  let(:controller)       { controller_class.new }
  let(:view_context)     { double('view_context') }

  describe 'memoize_context' do
    before do
      controller_class.send(:include, described_class)
      allow(controller).to receive(:view_context) { view_context }
    end

    it 'memoizes the current controller and view_context' do
      expect(Lappen::RequestContext).to receive(:controller=).with(controller)
      expect(Lappen::RequestContext).to receive(:view_context=).with(view_context)

      controller.send(:memoize_context)
    end
  end
end
