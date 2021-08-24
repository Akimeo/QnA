feature 'User can sign up', %q{
  In order to sign in
  As a new user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'some@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
