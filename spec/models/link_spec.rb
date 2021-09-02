describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { is_expected.to validate_url_of(:url) }

  describe '#gist?' do
    subject(:link_url) { link.url }

    context 'when url is a gist' do
      let(:link) { create(:link, :gist) }

      it { is_expected.to match(%r{^https://gist.github.com/\w+/\w{32}$}) }
    end

    context 'when url is not a gist' do
      let(:link) { create(:link) }

      it { is_expected.to_not match(%r{^https://gist.github.com/\w+/\w{32}$}) }
    end
  end
end
