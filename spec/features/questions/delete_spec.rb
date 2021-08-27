feature 'Author can delete question', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my question or its files
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given!(:question) { create(:question, author: author, files: [fixture_file_upload('spec/rails_helper.rb')]) }

  describe 'Author' do
    background do
      sign_in(author)

      visit questions_path
    end

    scenario 'deletes their question' do
      click_on 'Delete'

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario 'deletes files attached to their question', js: true do
      within '.question-files' do
        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end
  end

  scenario "Authenticated user tries to delete someone else's question" do
    sign_in(some_user)
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end

  scenario "Unauthenticated user tries to delete an question" do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
