require 'spec_helper'

describe Lappen::Scope do
  describe '.lappen' do
    let(:params) { double('params') }

    before do
      class Model
        extend Lappen::Scope
      end

      ModelFilterStack = Class.new(Lappen::FilterStack)
    end

    after do
      Object.send(:remove_const, :Model)
      Object.send(:remove_const, :ModelFilterStack)
    end

    it 'calls #perform on the associated Lappen' do
      expect(ModelFilterStack).to receive(:perform).with(Model, params)
      Model.lappen(params)
    end
  end
end
