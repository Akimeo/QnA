feature 'User can view answer rating', %q{
  In order to distinguish helpful information
  As a user
  I'd like to be able to view answer rating
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:votes) { create_list(:vote, 3, votable: answer) }

  scenario 'User views the question rating' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Rating: 3'
    end
  end
end
