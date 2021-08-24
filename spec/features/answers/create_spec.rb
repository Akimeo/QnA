feature 'User can create answer', %q{
  In order to answer the question
  As an authenticated user who visits the question page
  I'd like to be able to post an answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'posts an answer' do
      fill_in 'Body', with: 'Testing answer creation'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully posted.'
      expect(page).to have_content 'Testing answer creation'
    end

    scenario 'posts an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(question)
    fill_in 'Body', with: "This shouldn't be posted"
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
