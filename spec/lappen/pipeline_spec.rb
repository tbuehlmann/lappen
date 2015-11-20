require 'spec_helper'

describe Lappen::Pipeline do
  before do
    ProductPipeline = Class.new(described_class)
  end

  after do
    Object.send(:remove_const, :ProductPipeline)
  end

  subject { ProductPipeline }

  let(:scope)  { Product.all }
  let(:params) { {} }

  describe '.find' do
    context 'with the argument responding to .pipeline_class' do
      before do
        class MyProduct < ActiveRecord::Base
          def self.pipeline_class
            ProductPipeline
          end
        end
      end

      after do
        Object.send(:remove_const, :MyProduct)
      end

      it 'returns the deposited class' do
        expect(described_class.find(MyProduct)).to eq(subject)
      end
    end

    context 'with the argument not responding to .pipeline_class' do
      it 'returns class name appended with "Pipeline"' do
        expect(described_class.find(Product)).to eq(subject)
      end
    end
  end

  describe '.use' do
    it 'adds the arguments to the filters variable' do
      subject.use(Object, 42, foo: 'bar')
      expect(subject.filters).to match_array([[Object, [42], {foo: 'bar'}]])
    end
  end

  describe '.perform' do
    it 'instantiates the class and runs #perform' do
      expect_any_instance_of(subject).to receive(:perform).once
      subject.perform(scope, params)
    end
  end

  describe '.inherited' do
    it 'dups the filters to the subclass' do
      subject.use(Lappen::Filter)
      subclass = Class.new(subject)

      expect(subclass.filters).to match_array(subject.filters)
    end
  end

  describe '#initialize' do
    subject { Class.new(described_class).new(scope, params) }

    it 'stores params as a HashWithIndifferentAccess' do
      expect(subject.params).to be_kind_of(HashWithIndifferentAccess)
    end
  end

  describe '#perform' do
    let(:halter) do
      Class.new(Lappen::Filter) do
        def perform(scope, params = {})
          throw(:halt, {})
        end
      end
    end

    it 'calls #perform on each filter from the pipeline' do
      subject.use(Lappen::Filters::Equal)
      subject.use(Lappen::Filters::Comparable)

      expect_any_instance_of(Lappen::Filters::Equal).to receive(:perform).once.and_call_original
      expect_any_instance_of(Lappen::Filters::Comparable).to receive(:perform).once.and_call_original

      subject.perform(scope, params)
    end

    it 'catches :halt and returns it' do
      subject.use(halter)
      subject.use(Lappen::Filters::Equal)

      expect_any_instance_of(halter).to receive(:perform).once.and_call_original
      expect_any_instance_of(Lappen::Filters::Equal).not_to receive(:perform)

      filtered_scope = subject.perform(scope, params)
      expect(filtered_scope).to eq({})
    end
  end
end
