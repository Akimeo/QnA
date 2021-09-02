feature 'User can view award list', %q{
  In order to admire my greatness
  As an authenticated user
  I'd like to be able to view the list of my awards
} do
  given(:user) { create(:user) }
  given!(:awards) { create_list(:award, 3, user: user) }

  scenario 'Authenticated user views the list of their awards' do
    sign_in(user)

    visit awards_path

    awards.each do |award|
      expect(page).to have_content award.question.title
      expect(page).to have_css("img[src*='#{award.image.filename}']")
      expect(page).to have_content award.title
    end
  end

  scenario 'Unauthenticated user tries to view the list of awards' do
    visit awards_path

    expect(page).to have_content 'Sign in to see your awards'
  end
end
