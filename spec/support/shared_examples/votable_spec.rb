shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    subject { model.rating }

    let(:model) { create(described_class.to_s.underscore.to_sym) }

    context 'when votes are positive' do
      let!(:votes) { create_list(:vote, 3, votable: model) }

      it { is_expected.to eq 3 }
    end

    context 'when votes are positive' do
      let!(:votes) { create_list(:vote, 3, votable: model, status: -1) }

      it { is_expected.to eq -3 }
    end

    context 'when votes are mixed' do
      let!(:upvotes) { create_list(:vote, 3, votable: model) }
      let!(:downvotes) { create_list(:vote, 3, votable: model, status: -1) }

      it { is_expected.to eq 0 }
    end
  end

  describe '#vote_of?' do
    subject { model.vote_of(user) }

    let(:model) { create(described_class.to_s.underscore.to_sym) }
    let(:user) { create(:user) }

    context 'when user voted' do
      let!(:vote) { create(:vote, votable: model, author: user) }

      it { is_expected.to eq user.votes.first }
    end

    context 'when user did not vote' do
      it { is_expected.to eq nil }
    end
  end
end
