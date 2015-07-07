require 'spec_helper'

describe Lappen::Filters::Comparable do
  subject { described_class.new(*args, meta: meta) }

  let(:args)  { [:price] }
  let(:meta)  { {} }
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
      let(:params) { {price_min: 3} }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(2)
      end

      it 'adds meta information' do
        subject.perform(scope, params)
        expect(meta[:comparable]).to eq(min: {price: 3}, max: {})
      end
    end

    context 'with a maximum' do
      let(:params) { {price_max: 3} }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(1)
      end

      it 'adds meta information' do
        subject.perform(scope, params)
        expect(meta[:comparable]).to eq(min: {}, max: {price: 3})
      end
    end

    context 'with a range' do
      let(:params) { {price_min: 2, price_max: 4} }

      it 'filters the scope' do
        products = subject.perform(scope, params)
        expect(products.count).to eq(2)
      end

      it 'adds meta information' do
        subject.perform(scope, params)
        expect(meta[:comparable]).to eq(min: {price: 2}, max: {price: 4})
      end
    end
  end
end
