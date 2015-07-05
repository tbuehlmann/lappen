require 'spec_helper'

describe Lappen::Notifications do
  describe 'included' do
    let(:scope)  { double('scope') }
    let(:filter) { Class.new(Lappen::Filter) }

    let(:stack) do
      Class.new(Lappen::FilterStack).tap do |klass|
        klass.__send__(:include, described_class)
        klass.use filter
      end
    end

    it 'will fanout lappen.perform events' do
      expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.perform', hash_including(filter_stack: instance_of(stack)))
      stack.perform(scope)
    end

    it 'will fanout lappen.filter events' do
      allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
      expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.filter', hash_including(filter_stack: instance_of(stack), filter: instance_of(filter)))

      stack.perform(scope)
    end
  end
end
