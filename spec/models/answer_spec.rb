describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to(:author).class_name('User') }
  it { should belong_to :question }

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

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
      question.reload

      expect(question.best_answer).to eq nil
    end
  end
end
