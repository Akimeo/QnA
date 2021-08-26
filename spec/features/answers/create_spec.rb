feature 'User can create answer', %q{
  In order to answer the question
  As an authenticated user who visits the question page
  I'd like to be able to post an answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'posts an answer' do
      fill_in 'Body', with: 'Testing answer creation'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Testing answer creation'
      end
    end

    scenario 'posts an answer with errors' do
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea'
    expect(page).to have_content 'Sign in to answer questions'
  end
end
