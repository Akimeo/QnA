feature 'User can subscribe to question updates', %q{
  In order to stay tuned
  As an authenticated user
  I'd like to be able to subscribe to question updates
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:subscribed_question) { create(:question) }
    given!(:subscription) { create(:subscription, user: user, question: subscribed_question) }

    background { sign_in(user) }

    scenario 'subscribes to question updates' do
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to have_content 'You are subscribed to this question updates'
      expect(page).to have_selector(:link_or_button, 'Unsubscribe')
      expect(page).to_not have_selector(:link_or_button, 'Subscribe')
    end

    scenario 'cancels subscription' do
      visit question_path(subscribed_question)

      click_on 'Unsubscribe'

      expect(page).to have_content 'Receive notification letters when new answers appear'
      expect(page).to have_selector(:link_or_button, 'Subscribe')
      expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
    end

    scenario 'tries to cancel non-existent subscription' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
    end
  end

  describe 'Question author', js: true do

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Subscription testing title'
      fill_in 'Body', with: 'Subscription testing body'
      click_on 'Ask'
    end

    scenario 'is subscribed automatically' do
      expect(page).to have_content 'You are subscribed to this question updates'
      expect(page).to have_selector(:link_or_button, 'Unsubscribe')
      expect(page).to_not have_selector(:link_or_button, 'Subscribe')
    end

    scenario 'can cancel subscription' do
      click_on 'Unsubscribe'

      expect(page).to have_content 'Receive notification letters when new answers appear'
      expect(page).to have_selector(:link_or_button, 'Subscribe')
      expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to subscribe to question updates' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Subscribe')
    end

    scenario 'tries to cancel subscription' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
    end
  end
end
