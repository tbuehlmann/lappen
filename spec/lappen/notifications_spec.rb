require 'spec_helper'

describe Lappen::Notifications do
  describe 'included' do
    let(:scope)   { double('scope') }
    let(:params)  { {} }
    let(:filter)  { Class.new(Lappen::Filter) }

    let(:pipeline) do
      Class.new(Lappen::Pipeline).tap do |klass|
        klass.__send__(:include, described_class)
        klass.use filter
      end
    end

    it 'will fanout lappen.perform events' do
      expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.perform', hash_including(pipeline: instance_of(pipeline)))
      pipeline.perform(scope, params)
    end

    it 'will fanout lappen.filter events' do
      allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
      expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.filter', hash_including(pipeline: instance_of(pipeline), filter: instance_of(filter)))

      pipeline.perform(scope, params)
    end
  end
end
