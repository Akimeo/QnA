feature 'Author can delete answer', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my answer and any attached components
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question, files: [fixture_file_upload('spec/rails_helper.rb')]) }
  given(:google_url) { 'https://www.google.com/' }
  given!(:link) { create(:link, linkable: answer, name: 'Google', url: google_url) }


  describe 'Author', js: true do
    background do
      sign_in(author)

      visit question_path(question)
    end

    scenario 'deletes their answer' do
      click_on 'Delete'

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content answer.body
    end

    scenario 'deletes file attached to their answer' do
      within '.answers .files' do
        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'deletes link attached to their answer', js: true do
      within '.answers .links' do
        click_on 'Delete link'

        expect(page).to_not have_link 'Google', href: google_url
      end
    end
  end

  scenario "Authenticated user tries to delete someone else's answer" do
    sign_in(some_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
