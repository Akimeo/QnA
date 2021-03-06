describe DailyDigestJob, type: :job do
  let(:service) { instance_double('DailyDigestService') }

  before { allow(DailyDigestService).to receive(:new).and_return(service) }

  it 'calls DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
