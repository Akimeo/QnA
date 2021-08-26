describe Answer, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '#best?' do
    let(:question) { create(:question) }
    subject(:answer) { create(:answer, question: question) }

    context 'when answer is the best' do
      before { question.update(best_answer: answer) }

      it { is_expected.to eq question.best_answer }
    end

    context 'when answer is not the best' do
      it { is_expected.to_not eq question.best_answer }
    end
  end

  describe '#nullify_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'sets question best_answer value to nil' do
      question.update(best_answer: answer)
      answer.destroy

      expect(question.best_answer).to eq nil
    end
  end
end
