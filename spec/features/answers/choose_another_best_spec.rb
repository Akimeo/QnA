feature 'Question author can choose another best answer', %q{
  In order to highlight more helpful information
  As an author of question who has already chosen the best answer
  I'd like to be able to choose another best answer
} do
  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:first_answer) { create(:answer, question: question) }
  given!(:second_answer) { create(:answer, question: question) }

  scenario 'Question author chooses another best answer', js: true do
    sign_in(author)
    visit question_path(question)

    page.find("#answer-#{second_answer.id}").click_link('Mark as best')
    page.find("#answer-#{first_answer.id}").click_link('Mark as best')

    expect(page.find("#answer-#{first_answer.id}")).to have_content 'The best answer!'
    expect(page.find("#answer-#{second_answer.id}")).to_not have_content 'The best answer!'
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
