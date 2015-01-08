shared_examples 'a filter that calls the stack' do
  it 'calls stack#perform' do
    expect(stack).to receive(:perform)
    subject.perform(scope, params)
  end
end
