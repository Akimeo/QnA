describe QuestionUpdatesService do
  describe '#send_update' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    let(:subscribed_user) { create(:user) }
    let!(:subscription) { create(:subscription, user: subscribed_user, question: question) }

    let!(:user) { create(:user) }

    let(:answer) { create(:answer, question: question) }

    it 'sends question update to all subscribed users' do
      expect(QuestionUpdatesMailer).to receive(:send_update).with(author, answer).and_call_original
      expect(QuestionUpdatesMailer).to receive(:send_update).with(subscribed_user, answer).and_call_original
      expect(QuestionUpdatesMailer).not_to receive(:send_update).with(user, answer)
      subject.send_update(answer)
    end
  end
end
