feature 'Author can delete answer', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my answer
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question) }

  scenario 'Author deletes their answer' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete'

    expect(page).not_to have_content answer.body
  end

  scenario "Authenticated user tries to delete someone else's answer" do
    sign_in(some_user)
    visit question_path(question)

    expect(page).not_to have_content 'Delete'
  end

  scenario "Unauthenticated user tries to delete an answer" do
    visit question_path(question)

    expect(page).not_to have_content 'Delete'
  end
end
