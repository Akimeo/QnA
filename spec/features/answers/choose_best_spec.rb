feature 'Question author can choose best answer', %q{
  In order to highlight helpful information
  As an author of question
  I'd like to be able to choose the best answer
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:first_answer) { create(:answer, question: question) }
  given!(:second_answer) { create(:answer, question: question) }

  scenario 'Question author chooses the best answer', js: true do
    sign_in(author)
    visit question_path(question)
    first('.answer').click_link('Mark as best')

    expect(first('.answer')).to have_content 'The best answer!'
    expect(all('.answer').last).to_not have_content 'The best answer!'
  end

  scenario "Authenticated user tries to mark someone else's question answer as best" do
    sign_in(some_user)
    visit question_path(question)

    expect(page).to_not have_content 'Mark as best'
  end

  scenario "Unauthenticated user tries to mark an answer as best" do
    visit question_path(question)

    expect(page).to_not have_content 'Mark as best'
  end
end
