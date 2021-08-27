feature 'Author can delete answer', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my answer or its files
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question, files: [fixture_file_upload('spec/rails_helper.rb')]) }


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

    scenario 'deletes files attached to their answer' do
      within '.answer-files' do
        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
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
