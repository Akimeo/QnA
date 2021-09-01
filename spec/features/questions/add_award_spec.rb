feature 'Question author can create award for best answer', %q{
  In order to thank helpful people
  As a question author
  I'd like to able to create an award for the best answer
} do

  given(:user) { create(:user) }

  describe 'User creates a new question' do

    background do
      sign_in(user)

      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
    end

    scenario 'with a valid award' do
      fill_in 'Award Title', with: 'I AM LEG'
      attach_file 'Image', "#{Rails.root}/public/leg.png"

      click_on 'Ask'

      expect(page).to have_content 'Recieve I AM LEG award for the best answer!'
      expect(page).to have_css "img[src*='leg.png']"
    end

    scenario 'with an invalid award' do
      fill_in 'Award Title', with: 'I AM WRONG'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Ask'

      expect(page).to have_content 'Award image has an invalid content type'
    end
  end
end
