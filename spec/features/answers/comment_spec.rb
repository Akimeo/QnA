feature 'User can comment answers', %q{
  In order to communicate with other users
  As an authenticated user
  I'd like to be able to comment answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments an answer' do
      within '.answers' do
        fill_in 'Comment', with: 'Comment Text'
        click_on 'Post'

        expect(page).to have_content 'Comment Text'
      end
    end

    scenario 'comments an answer with errors' do
      within '.answers' do
        click_on 'Post'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Authenticated user comments an answer and', js: true do
    given(:other_question) { create(:question) }
    given!(:other_answer) { create(:answer, question: other_question) }

    scenario 'this comment appears in another user session' do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        within '.answers' do
          fill_in 'Comment', with: 'Comment Text'
          click_on 'Post'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Comment Text'
        end
      end
    end

    scenario 'this comment does not appear on another question page' do
      Capybara.using_session('guest') do
        visit question_path(other_question)
      end

      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)

        within '.answers' do
          fill_in 'Comment', with: 'Comment Text'
          click_on 'Post'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to_not have_content 'Comment Text'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to comment an answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Sign in to comment answers'
      expect(page).to_not have_selector 'textarea'
    end
  end
end
