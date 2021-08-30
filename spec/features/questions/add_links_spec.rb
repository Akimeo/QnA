feature 'User can add links to question', %q{
  In order to provide additional information
  As a question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Akimeo/f76accba429d1759f0db4f684706a13a' }

  scenario 'User adds link to new question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end    
