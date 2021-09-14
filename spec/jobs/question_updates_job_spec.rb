describe QuestionUpdatesJob, type: :job do
  let(:service) { double('QuestionUpdatesService') }
  let(:answer) { create(:answer) }

  before { allow(QuestionUpdatesService).to receive(:new).and_return(service) }

  it 'calls QuestionUpdates#send_update' do
    expect(service).to receive(:send_update)
    QuestionUpdatesJob.perform_now(answer)
  end
end
