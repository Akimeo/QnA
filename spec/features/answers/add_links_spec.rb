feature 'User can add links to answer', %q{
  In order to provide additional information
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Akimeo/f76accba429d1759f0db4f684706a13a' }

  scenario 'User adds link to new question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Testing answer creation'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
