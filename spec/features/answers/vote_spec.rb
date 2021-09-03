feature 'User can vote for answer', %q{
  In order to show my opinion
  As an authenticated user
  I'd like to be able to upvote, downvote and cancel my vote for an answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'upvotes an answer' do
      within '.answers' do
        click_on 'Upvote'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'Upvoted!'
      end
    end

    scenario 'downvotes an answer' do
      within '.answers' do
        click_on 'Downvote'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Downvoted!'
      end
    end
  end

  describe 'User who already voted', js: true do
    given!(:vote) { create(:vote, author: user, votable: answer) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries to vote second time' do
      within '.answers' do
        expect(page).to have_content 'Upvoted!'
        expect(page).not_to have_content 'Downvote'
      end
    end

    scenario 'cancels their vote and votes again' do
      within '.answers' do
        click_on 'Cancel'
        click_on 'Downvote'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Downvoted!'
      end
    end
  end

  scenario 'Author tries to vote for their answer' do
    sign_in(author)

    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Upvote'
      expect(page).not_to have_content 'Downvote'
    end
  end

  scenario 'Unauthenticated user tries to vote for an answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Upvote'
      expect(page).not_to have_content 'Downvote'
    end
  end
end
