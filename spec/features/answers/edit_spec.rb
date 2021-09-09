feature 'Author can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question) }

  describe 'Author', js: true do

    background do
      sign_in(author)

      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edits their answer' do
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea#answer_body'
      end
    end

    scenario 'edits their answer with errors' do
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea#answer_body'
      end
    end

    scenario 'edits their answer with attaching files' do
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "Authenticated user tries to edit someone else's answer" do
    sign_in(some_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
