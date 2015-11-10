require 'spec_helper'

describe Lappen::Scope do
  describe '.lappen' do
    let(:params) { double('params') }

    before do
      class Category < ActiveRecord::Base
        extend Lappen::Scope
      end

      CategoryPipeline = Class.new(Lappen::Pipeline)
    end

    after do
      Object.send(:remove_const, :Category)
      Object.send(:remove_const, :CategoryPipeline)
    end

    it 'calls #perform on the associated Lappen' do
      expect(CategoryPipeline).to receive(:perform).with(Category, params)
      Category.lappen(params)
    end
  end
end
