describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').dependent(:destroy) }
  it { should have_many(:answers).with_foreign_key('author_id').dependent(:destroy) }

  describe '#author_of?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:question) { create(:question, author: user) }

      it { is_expected.to be_author_of(question) }
    end

    context 'when user is not the author' do
      let(:question) { create(:question) }

      it { is_expected.not_to be_author_of(question) }
    end
  end
end
