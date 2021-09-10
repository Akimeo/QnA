describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: question.files.first }, format: :js }

    before do
      login(user)

      delete_destroy
    end

    context 'user is the author' do
      let(:question) { create(:question, author: user, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'deletes the attachment' do
        expect(question.reload.files).to_not be_attached
      end

      it 'renders destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'user is not the author' do
      let(:question) { create(:question, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'does not delete the attachment' do
        expect(question.reload.files).to be_attached
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
