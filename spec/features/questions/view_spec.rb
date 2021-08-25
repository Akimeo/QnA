feature 'User can view question', %q{
  In order to find information
  As a user
  I'd like to be able to view the question and it's answers
} do

  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User tries to view the question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
