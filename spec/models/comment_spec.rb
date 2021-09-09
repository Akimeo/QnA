describe Comment, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }

  describe '#question' do
    subject { comment.question }

    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    context 'when commentable is Question' do
      let(:comment) { create(:comment, commentable: question) }

      it { is_expected.to eq question }
    end

    context 'when commentable is Answer' do
      let(:comment) { create(:comment, commentable: answer) }

      it { is_expected.to eq question }
    end
  end
end
