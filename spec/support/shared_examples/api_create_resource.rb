shared_examples_for 'API Creatable' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:post_create) { post api_path, params: { access_token: access_token.token }.merge(resource_params), headers: headers }

  context 'with valid attributes' do
    let(:resource_params) { valid_attributes }
    let(:new_resource) { resource_class.order(:created_at).last }

    it 'bonds a new resource with the author' do
      post_create

      expect(user).to be_author_of(new_resource)
    end

    it 'saves a new resource in the database' do
      expect { post_create }.to change(resource_class, :count).by(1)
    end

    it 'returns successful status' do
      post_create

      expect(response).to be_successful
    end
  end

  context 'with invalid attributes' do
    let(:resource_params) { invalid_attributes }

    it 'does not save a new resource in the database' do
      expect { post_create }.to_not change(resource_class, :count)
    end

    it 'returns unprocessable entity status' do
      post_create

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
