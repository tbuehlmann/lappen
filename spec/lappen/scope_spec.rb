require 'spec_helper'

describe Lappen::Scope do
  describe '.lappen' do
    let(:params) { double('params') }

    before do
      class Model
        extend Lappen::Scope
      end

      ModelLappen = Class.new(Lappen::FilterStack)
    end

    after do
      Object.send(:remove_const, :Model)
      Object.send(:remove_const, :ModelLappen)
    end

    it 'calls #perform on the associated Lappen' do
      expect(ModelLappen).to receive(:perform).with(Model, params)
      Model.lappen(params)
    end
  end
end
