describe QuestionUpdatesService do
  describe '#send_update' do
    let!(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    let(:answer) { create(:answer, question: question) }

    context 'when there are no other subscribers except author' do
      it 'sends new answer notification mail to question author only' do
        expect(QuestionUpdatesMailer).to receive(:send_update).with(author, answer).and_call_original
        expect(QuestionUpdatesMailer).not_to receive(:send_update).with(user, answer)
        subject.send_update(answer)
      end
    end

    context 'when there are other subscribers' do
      let(:subscribed_users) do
        create_list(:user, 2).tap do |users|
          users.each { |user| create :subscription, question: question, user: user }
        end
      end

      it 'sends new answer notification mail to all subsribed users of question' do
        (subscribed_users + [author]).each do |user|
          expect(QuestionUpdatesMailer).to receive(:send_update).with(user, answer).and_call_original
        end
        subject.send_update(answer)
      end
    end
  end
end
