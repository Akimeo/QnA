feature 'User can comment questions', %q{
  In order to communicate with other users
  As an authenticated user
  I'd like to be able to comment questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments a question' do
      fill_in 'Comment', with: 'Comment Text'
      click_on 'Post'

      expect(page).to have_content 'Comment Text'
    end

    scenario 'comments a question with errors' do
      click_on 'Post'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticated user comments a question and', js: true do
    given(:other_question) { create(:question) }

    scenario 'this comment appears in another user session' do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        fill_in 'Comment', with: 'Comment Text'
        click_on 'Post'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment Text'
      end
    end

    scenario 'this comment does not appear on another question page' do
      Capybara.using_session('guest') do
        visit question_path(other_question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        fill_in 'Comment', with: 'Comment Text'
        click_on 'Post'
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content 'Comment Text'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment a question' do
    visit question_path(question)

    expect(page).to have_content 'Sign in to comment questions'
    expect(page).to_not have_selector 'textarea'
  end
end
