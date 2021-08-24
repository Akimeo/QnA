feature 'Author can delete question', %q{
  In order to delete some content
  As its author
  I'd like to be able to delete my question
} do

  given(:author) { create(:user) }
  given(:some_user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Author deletes their question' do
    sign_in(author)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(page).not_to have_content question.title
  end

  scenario "Authenticated user tries to delete someone else's question" do
    sign_in(some_user)
    visit questions_path

    expect(page).not_to have_content 'Delete'
  end

  scenario "Unauthenticated user tries to delete an question" do
    visit questions_path

    expect(page).not_to have_content 'Delete'
  end
end
