require 'spec_helper'

describe Lappen::Callbacks do
  describe 'included' do
    let(:stack) do
      Class.new(Lappen::FilterStack).tap do |klass|
        klass.__send__(:include, described_class)
      end
    end

    [:perform, :filter].each do |action|
      [:before, :around, :after].each do |callback|
        method_name = "#{callback}_#{action}"

        it "adds a #{method_name} method" do
          expect(stack).to respond_to(method_name)
        end
      end
    end
  end
end
