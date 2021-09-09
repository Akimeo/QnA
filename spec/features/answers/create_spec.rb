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

    scenario 'posts an answer with attached files' do
      fill_in 'Body', with: 'Testing answer creation'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to post an answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea'
    expect(page).to have_content 'Sign in to answer questions'
  end

  describe 'Authenticated user answers a question and', js: true do
    given(:other_question) { create(:question) }

    scenario 'this answer appears in another user session' do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        fill_in 'Body', with: 'Testing answer creation'
        click_on 'Answer'
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Testing answer creation'
        end
      end
    end

    scenario 'this answer does not appear on another question page' do
      Capybara.using_session('guest') do
        visit question_path(other_question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        fill_in 'Body', with: 'Testing answer creation'
        click_on 'Answer'
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to_not have_content 'Testing answer creation'
        end
      end
    end
  end
end
