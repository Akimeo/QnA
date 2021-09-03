feature 'User can view question rating', %q{
  In order to distinguish helpful information
  As a user
  I'd like to be able to view question rating
} do

  given(:question) { create(:question) }
  given!(:votes) { create_list(:vote, 3, votable: question) }

  scenario 'User views the question rating' do
    visit question_path(question)

    within '.question' do
      expect(page).to have_content 'Rating: 3'
    end
  end
end
