feature 'User can add links to answer', %q{
  In order to provide additional information
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:invalid_url) { 'ttps://www.google.com/' }
  given(:gist_url) { 'https://gist.github.com/Akimeo/f76accba429d1759f0db4f684706a13a' }

  background { sign_in(user) }

  describe 'User creates a new answer', js: true do

    background do
      visit question_path(question)

      fill_in 'Body', with: 'Testing answer creation'
    end

    scenario 'with a valid link' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'with several valid links' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url
      end

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end

    scenario 'with an invalid link' do
      fill_in 'Link name', with: 'IAMERROR'
      fill_in 'Url', with: invalid_url

      click_on 'Answer'

      expect(page).to_not have_link 'IAMERROR', href: invalid_url

      within '.new-answer' do
        expect(page).to have_content 'Links url is not a valid URL'
      end
    end

    scenario 'with a gist link' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end

  describe 'User edits an answer', js: true do
    given!(:answer) { create(:answer, question: question, author: user) }

    background do
      visit question_path(question)

      click_on 'Edit'
    end

    context "that doesn't have links yet" do

      scenario 'with adding several valid links' do
        within '.answers' do
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
      end

      scenario 'with adding an invalid link' do
        within '.answers' do
          click_on 'add link'

          fill_in 'Link name', with: 'IAMERROR'
          fill_in 'Url', with: invalid_url

          click_on 'Save'

          expect(page).to_not have_link 'IAMERROR', href: invalid_url
          expect(page).to have_content 'Links url is not a valid URL'
        end
      end
    end

    context "that already has links" do
      given!(:link) { create(:link, linkable: answer, name: 'Google', url: google_url) }

      scenario 'with adding a valid link' do
        within '.answers' do
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
end
