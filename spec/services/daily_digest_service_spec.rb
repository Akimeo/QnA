describe DailyDigestService do
  let(:users) { (create_list :user, 2) }
  let!(:before_yesterday_question) { create :question, created_at: 2.days.ago.end_of_day }
  let!(:yesterday_questions) { create_list :question, 2, created_at: 1.day.ago.beginning_of_day }

  it 'sends daily digest to all users' do
    User.all.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user, yesterday_questions).and_call_original
    end
    subject.send_digest
  end
 end
