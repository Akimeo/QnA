feature 'User can view question list', %q{
  In order to find information
  As a user
  I'd like to be able to view the list of questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User tries to view the list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
