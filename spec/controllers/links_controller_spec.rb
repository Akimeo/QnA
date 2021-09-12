describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: link }, format: :js }

    before { login(user) }

    context 'user is the author' do
      let(:question) { create(:question, author: user) }
      let!(:link) { create(:link, linkable: question) }

      it 'deletes the link' do
        expect { delete_destroy }.to change(Link, :count).by(-1)
      end

      it 'renders destroy view' do
        delete_destroy

        expect(response).to render_template :destroy
      end
    end

    context 'user is not the author' do
      let!(:link) { create(:link) }

      it 'does not delete the link' do
        expect { delete_destroy }.to_not change(Link, :count)
      end

      it 'returns forbidden status' do
        delete_destroy

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
