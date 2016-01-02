require 'spec_helper'
require 'kaminari'
Kaminari::Hooks.init

describe Lappen::Filters::Kaminari do
  subject { described_class.new(**options.merge(meta: meta)) }

  let(:options)  { {} }
  let(:meta)     { {} }
  let(:scope)    { Product.all }

  shared_examples 'for different options' do
    it 'calls #page, #per and #padding on the scope with the corresponding params' do
      paginated_scope = subject.perform(scope, params)

      expect(paginated_scope.current_page).to eq(5)
      expect(paginated_scope.limit_value).to eq(42)
      expect(paginated_scope.instance_variable_get(:@_padding)).to eq(3)
    end

    it 'adds meta information' do
      subject.perform(scope, params)
      expect(meta[:pagination]).to eq(page: 5, per: 42, padding: 3)
    end
  end

  describe '#perform' do
    context 'without custom keys provided' do
      let(:params) { {page: 5, per: 42, padding: 3} }
      include_examples 'for different options'
    end

    context 'with custom keys provided' do
      let(:options) { {page_key: :seite, per_key: :pro, padding_key: :ohne} }
      let(:params)  { {seite: 5, pro: 42, ohne: 3} }

      include_examples 'for different options'
    end
  end
end
