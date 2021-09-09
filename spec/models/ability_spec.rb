describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, author: user) }
    let(:question_with_file) { create(:question, author: user, files: [fixture_file_upload('spec/rails_helper.rb')]) }
    let(:link) { create(:link, linkable: question) }
    let(:voted_question) { create(:question) }
    let!(:vote) { create(:vote, author: user, votable: voted_question) }

    let(:other_question) { create(:question) }
    let(:other_answer) { create(:answer) }
    let(:other_question_with_file) { create(:question, files: [fixture_file_upload('spec/rails_helper.rb')]) }
    let(:other_link) { create(:link) }
    let(:other_vote) { create(:vote) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :create_vote, other_question }
    it { should_not be_able_to :create_vote, question }
    it { should_not be_able_to :create_vote, voted_question }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :destroy, question_with_file.files.first }
    it { should_not be_able_to :destroy, other_question_with_file.files.first }

    it { should be_able_to :destroy, link }
    it { should_not be_able_to :destroy, other_link }

    it { should be_able_to :destroy, vote }
    it { should_not be_able_to :destroy, other_vote }

    it { should be_able_to :choose_best_answer, question }
    it { should_not be_able_to :choose_best_answer, other_question }
  end
end
