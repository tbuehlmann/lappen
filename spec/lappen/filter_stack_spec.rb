require 'spec_helper'

describe Lappen::FilterStack do
  subject { Class.new(described_class) }
  let(:scope)  { double('scope') }
  let(:params) { double('params') }

  describe '.find' do
    let(:model) { double('model') }

    context 'with the argument responding to .filter_stack_class' do
      it 'returns the deposited class' do
        allow(model).to receive(:filter_stack_class) { subject }
        expect(described_class.find(model)).to eq(subject)
      end
    end

    context 'with the argument not responding to .filter_stack_class' do
      before do
        allow(model).to receive(:to_s) { 'Model' }
        ModelFilterStack = subject
      end

      after do
        Object.send(:remove_const, :ModelFilterStack)
      end

      it 'returns class name appended with "FilterStack"' do
        expect(described_class.find(model)).to eq(subject)
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
      expect_any_instance_of(subject).to receive(:perform).with(scope, params).once
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

  describe '#perform' do
    let(:stack) { subject.new }

    let(:add_one) do
      Class.new(Lappen::Filter) do
        def perform(scope, params = {})
          scope + 1
        end
      end
    end

    let(:add_two) do
      Class.new(Lappen::Filter) do
        def perform(scope, params = {})
          scope + 2
        end
      end
    end

    let(:halter) do
      Class.new(Lappen::Filter) do
        def perform(scope, params = {})
          throw(:halt, 42)
        end
      end
    end

    it 'calls #perform on each filter from the stack' do
      subject.use(add_one)
      subject.use(add_two)

      expect_any_instance_of(add_one).to receive(:perform).with(0, params).once.and_call_original
      expect_any_instance_of(add_two).to receive(:perform).with(1, params).once.and_call_original

      stack.perform(0, params)
    end

    it 'returns filtered scope' do
      subject.use(add_one)
      subject.use(add_two)

      filtered_scope = stack.perform(0, params)
      expect(filtered_scope).to eq(3)
    end

    it 'catches :halt and returns it' do
      subject.use(halter)
      subject.use(add_one)
      subject.use(add_two)

      filtered_scope = stack.perform(0, params)
      expect(filtered_scope).to eq(42)
    end
  end
end
