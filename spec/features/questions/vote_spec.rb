feature 'User can vote for question', %q{
  In order to show my opinion
  As an authenticated user
  I'd like to be able to upvote, downvote and cancel my vote for a question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'upvotes a question' do
      within '.question-show' do
        click_on 'Upvote'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'Upvoted!'
      end
    end

    scenario 'downvotes a question' do
      within '.question-show' do
        click_on 'Downvote'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Downvoted!'
      end
    end
  end

  describe 'User who already voted', js: true do
    given!(:vote) { create(:vote, author: user, votable: question) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries to vote second time' do
      within '.question-show' do
        expect(page).to have_content 'Upvoted!'
        expect(page).not_to have_content 'Downvote'
      end
    end

    scenario 'cancels their vote and votes again' do
      within '.question-show' do
        click_on 'Cancel'
        click_on 'Downvote'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Downvoted!'
      end
    end
  end

  scenario 'Author tries to vote for their question' do
    sign_in(author)

    visit question_path(question)

    within '.question-show' do
      expect(page).not_to have_content 'Upvote'
      expect(page).not_to have_content 'Downvote'
    end
  end

  scenario 'Unauthenticated user tries to vote for a question' do
    visit question_path(question)

    within '.question-show' do
      expect(page).not_to have_content 'Upvote'
      expect(page).not_to have_content 'Downvote'
    end
  end
end
