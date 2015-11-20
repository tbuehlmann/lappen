require 'spec_helper'

describe Lappen::Notifications do
  describe 'included' do
    let(:scope)   { Product.all }
    let(:params)  { {} }
    let(:filter)  { Class.new(Lappen::Filter) }

    let(:pipeline) do
      Class.new(Lappen::Pipeline).tap do |klass|
        klass.use(filter)
      end
    end

    context 'in a Pipeline' do
      before do
        pipeline.__send__(:include, described_class)
      end

      it 'will fanout lappen.pipeline.perform events' do
        expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.pipeline.perform', hash_including(pipeline: instance_of(pipeline))).and_call_original
        pipeline.perform(scope, params)
      end
    end

    context 'in a Filter' do
      before do
        filter.__send__(:include, described_class)
      end

      it 'will fanout lappen.filter.perform events' do
        expect(ActiveSupport::Notifications).to receive(:instrument).with('lappen.filter.perform', hash_including(filter: instance_of(filter))).and_call_original
        pipeline.perform(scope, params)
      end
    end
  end
end
