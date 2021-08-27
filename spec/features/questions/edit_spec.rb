feature 'Author can edit question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Author', js: true do

    background do
      sign_in(author)

      visit questions_path
      click_on 'Edit'
    end

    scenario 'edits their question' do
      fill_in 'Title', with: 'edited question title'
      fill_in 'Body', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to have_content 'edited question body'
      expect(page).to_not have_selector 'textfield'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits their question with errors' do
      fill_in 'Title', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'
    end
  end

  scenario "Authenticated user tries to edit someone else's question" do
    sign_in(some_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user tries to edit a question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
