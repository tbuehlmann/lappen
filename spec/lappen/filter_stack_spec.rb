require 'spec_helper'

describe Lappen::FilterStack do
  subject { Class.new(described_class) }
  let(:scope)  { double('scope') }
  let(:params) { double('params') }

  describe '.find' do
    let(:model) { double('model') }

    context 'with the argument responding to .lappen_class' do
      it 'returns the deposited class' do
        allow(model).to receive(:lappen_class) { subject }
        expect(described_class.find(model)).to eq(subject)
      end
    end

    context 'with the argument not responding to .lappen_class' do
      before do
        allow(model).to receive(:to_s) { 'Model' }
        ModelLappen = subject
      end

      after do
        Object.send(:remove_const, :ModelLappen)
      end

      it 'returns class name appended with "Lappen"' do
        expect(described_class.find(model)).to eq(subject)
      end
    end
  end

  describe '.use' do
    it 'adds the arguments to the filters variable' do
      subject.use(Object, 42, foo: 'bar')
      expect(subject.filters).to match_array([[Object, [42, {foo: 'bar'}]]])
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
    let(:stack)    { subject.new }
    let(:filter_1) { Class.new(Lappen::Filter) }
    let(:filter_2) { Class.new(Lappen::Filter) }

    before do
      subject.use(filter_1)
      subject.use(filter_2)
    end

    it 'calls #perform on the next filter from the stack' do
      expect_any_instance_of(filter_1).to receive(:perform).with(scope, params).once
      expect_any_instance_of(filter_2).to_not receive(:perform)

      stack.perform(scope, params)
    end

    it 'calls #perform on filters just once' do
      expect_any_instance_of(filter_1).to receive(:perform).with(scope, params).once
      expect_any_instance_of(filter_2).to receive(:perform).with(scope, params).once

      stack.perform(scope, params)
      stack.perform(scope, params)
    end

    it 'returns the scope argument if there are no more filters on the stack' do
      stack.perform(scope, params)
      stack.perform(scope, params)

      expect(stack.perform(scope, params)).to eq(scope)
    end
  end
end
