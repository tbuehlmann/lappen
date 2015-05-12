require 'spec_helper'

describe Lappen::Filters::Draper do
  subject { described_class.new }
  let(:scope)  { double('scope') }
  let(:params) { double('params') }

  describe '#perform' do
    it 'decorates the scope' do
      expect(scope).to receive(:decorate)
      subject.perform(scope, params)
    end
  end
end
