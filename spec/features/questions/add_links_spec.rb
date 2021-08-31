feature 'User can add links to question', %q{
  In order to provide additional information
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:invalid_url) { 'ttps://www.google.com/' }
  given(:gist_url) { 'https://gist.github.com/Akimeo/f76accba429d1759f0db4f684706a13a' }

  background { sign_in(user) }

  describe 'User creates a new question', js: true do

    background do
      visit new_question_path

      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
    end

    scenario 'with a valid link' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url

      click_on 'Ask'

      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'with several valid links' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url
      end

      click_on 'Ask'

      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end

    scenario 'with an invalid link' do
      fill_in 'Link name', with: 'IAMERROR'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to_not have_link 'IAMERROR', href: invalid_url
      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'with a gist link' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_content 'Hello, World!'
    end
  end

  describe 'User edits a question', js: true do
    given!(:question) { create(:question, author: user) }

    background do
      visit questions_path

      click_on 'Edit'
    end

    context "that doesn't have links yet" do

      scenario 'with adding several valid links' do
        click_on 'add link'

        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url

        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Yandex'
          fill_in 'Url', with: yandex_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'Yandex', href: yandex_url
      end

      scenario 'with adding an invalid link' do
        click_on 'add link'

        fill_in 'Link name', with: 'IAMERROR'
        fill_in 'Url', with: invalid_url

        click_on 'Save'

        expect(page).to_not have_link 'IAMERROR', href: invalid_url
        expect(page).to have_content 'Links url is not a valid URL'
      end
    end

    context "that already has links" do
      given!(:link) { create(:link, linkable: question, name: 'Google', url: google_url) }

      scenario 'with adding a valid link' do
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Yandex'
          fill_in 'Url', with: yandex_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end
  end
end
