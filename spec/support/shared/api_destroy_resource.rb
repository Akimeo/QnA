shared_examples_for 'API Destroyable' do
  let(:delete_destroy) { delete api_path, params: { access_token: access_token.token }, headers: headers }

  context 'User is the author' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it 'deletes the resource' do
      expect { delete_destroy }.to change(resource.class, :count).by(-1)
    end

    it 'returns successful status' do
      delete_destroy

      expect(response).to be_successful
    end
  end

  context 'User is not the author' do
    let(:access_token) { create(:access_token) }

    it 'does not delete the resource' do
      expect { delete_destroy }.to_not change(resource.class, :count)
    end

    it 'returns forbidden status' do
      delete_destroy

      expect(response).to have_http_status(:forbidden)
    end
  end
end
