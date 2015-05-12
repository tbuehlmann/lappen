require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

describe Lappen::Filters::Comparable do
  subject { described_class.new(*args) }
  let(:args)  { [:price] }
  let(:scope) { Product.all }

  before(:all) do
    Product.create(price: 2)
    Product.create(price: 4)
    Product.create(price: 6)
  end

  after(:all) do
    Product.delete_all
  end

  describe '#perform' do
    context 'with a minimum' do
      let(:params) { {price_min: '3'}.with_indifferent_access }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(2)
      end
    end

    context 'with a maximum' do
      let(:params) { {price_max: '3'}.with_indifferent_access }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(1)
      end
    end

    context 'with a range' do
      let(:params) { {price_min: '2', price_max: '4'}.with_indifferent_access }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(2)
      end
    end
  end
end
