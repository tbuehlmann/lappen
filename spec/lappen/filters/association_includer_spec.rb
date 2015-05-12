require 'spec_helper'

describe Lappen::Filters::AssociationIncluder do
  subject { described_class.new(*args) }
  let(:args)   { [:category, :reviews] }
  let(:scope)  { double('scope') }
  let(:params) { double('params') }
  let(:filtered_scope) { double('filtered scope') }

  describe '#perform' do
    it '#includes the arguments in the scope' do
      expect(scope).to receive(:includes).with(args)
      subject.perform(scope, params)
    end
  end
end
