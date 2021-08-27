feature 'The best answer shown first', %q{
  In order to quickly find helpful information
  As a user
  Id'd like to see the best answer first
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:first_answer) { create(:answer, question: question) }
  given!(:second_answer) { create(:answer, question: question) }

  scenario 'User sees the best answer first', js: true do
    question.update(best_answer: second_answer)
    visit question_path(question)

    expect(first('.answer')).to have_content 'The best answer!'
    expect(first('.answer')).to have_content second_answer.body
  end

  scenario 'User sees the best answer first when he marks it', js: true do
    sign_in(user)
    visit question_path(question)
    page.find("#answer-#{second_answer.id}").click_link('Mark as best')

    expect(first('.answer')).to eq page.find("#answer-#{second_answer.id}")
  end
end
