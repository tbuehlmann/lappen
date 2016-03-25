require 'spec_helper'

describe Lappen::Scope do
  before do
    Product.extend(described_class)
  end

  describe '.pipeline' do
    it 'calls #perform on the associated Pipeline' do
      expect(ProductPipeline).to receive(:perform).with(Product, {})
      Product.pipeline({})
    end
  end
end
