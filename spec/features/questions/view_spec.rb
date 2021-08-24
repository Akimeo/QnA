feature 'User can view question', %q{
  In order to find information
  As a user
  I'd like to be able to view the question and it's answers
} do

  scenario 'User tries to view the question page' do
    question = create(:question)
    first_answer = create(:answer, question: question)
    second_answer = create(:answer, question: question)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content first_answer.body
    expect(page).to have_content second_answer.body
  end
end
