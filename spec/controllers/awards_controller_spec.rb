describe AwardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:awards) { create_list(:award, 3, user: user) }

    context 'User is authenticated' do

      before do
        login(user)

        get :index
      end

      it 'populates an array of all awards' do
        expect(assigns(:awards)).to match_array(awards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'User is not authenticated' do
      it 'renders index view' do
        get :index

        expect(response).to render_template :index
      end
    end
  end
end
