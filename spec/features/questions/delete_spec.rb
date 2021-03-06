feature 'Author can delete question', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my question and any attached components
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given!(:question) { create(:question, author: author, files: [fixture_file_upload('spec/rails_helper.rb')]) }
  given(:google_url) { 'https://www.google.com/' }
  given!(:link) { create(:link, linkable: question, name: 'Google', url: google_url) }

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

    scenario 'deletes file attached to their question', js: true do
      within '.files' do
        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'deletes link attached to their question', js: true do
      within '.links' do
        click_on 'Delete link'

        expect(page).to_not have_link 'Google', href: google_url
      end
    end
  end

  scenario "Authenticated user tries to delete someone else's question" do
    sign_in(some_user)
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to_not have_content 'Delete file'
    expect(page).to_not have_content 'Delete link'
  end

  scenario "Unauthenticated user tries to delete an question" do
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to_not have_content 'Delete file'
    expect(page).to_not have_content 'Delete link'
  end
end
