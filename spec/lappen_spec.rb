require 'spec_helper'
require 'action_view/test_case'

describe Lappen do
  describe '.setup_action_controller' do
    let(:controller) { ActionView::TestCase::TestController }

    it 'includes Lappen::RequestContext::Hooks into the argument' do
      expect(controller).to receive(:include).with(described_class::RequestContext::Hooks)
      described_class.setup_action_controller(controller)
    end
  end

  describe '.setup_active_record' do
    let(:model) { Class.new }

    it 'extends Lappen::Scope into the argument' do
      expect(model).to receive(:extend).with(described_class::Scope)
      described_class.setup_active_record(model)
    end
  end
end
