require 'spec_helper'

describe Lappen::RequestContext do
  let(:controller)   { double('controller') }
  let(:view_context) { double('view_context') }

  describe '.controller=' do
    it 'memoizes the current controller' do
      expect(RequestStore.store).to receive(:[]=).with(:lappen_controller, controller)
      described_class.controller = controller
    end
  end

  describe '.controller' do
    it 'gets the current controller' do
      expect(RequestStore.store).to receive(:[]).with(:lappen_controller)
      described_class.controller
    end
  end

  describe '.view_context=' do
    it 'memoizes the current view_context' do
      expect(RequestStore.store).to receive(:[]=).with(:lappen_view_context, view_context)
      described_class.view_context = view_context
    end
  end

  describe '.view_context' do
    it 'gets the current view_context' do
      expect(RequestStore.store).to receive(:[]).with(:lappen_view_context)
      described_class.view_context
    end
  end
end
