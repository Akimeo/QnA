shared_examples_for 'API Updatable' do
  let(:patch_update) { patch api_path, params: { access_token: access_token.token }.merge(resource_params), headers: headers }
  let(:new_attributes) { resource_params[resource_name] }

  context 'with valid attributes' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:resource_params) { valid_attributes }

    it 'changes resource attributes' do
      patch_update
      resource.reload

      new_attributes.each do |attr_name, value|
        expect(resource.send(attr_name)).to eq value
      end
    end

    it 'returns successful status' do
      patch_update

      expect(response).to be_successful
    end
  end

  context 'with invalid attributes' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:resource_params) { invalid_attributes }

    it 'does not change resource attributes' do
      patch_update
      resource.reload

      new_attributes.each do |attr_name, value|
        expect(resource.send(attr_name)).to_not eq value
      end
    end

    it 'returns unprocessable entity status' do
      patch_update

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'user is not the author' do
    let(:access_token) { create(:access_token) }
    let(:resource_params) { valid_attributes }


    it 'does not change resource attributes' do
      patch_update
      resource.reload

      new_attributes.each do |attr_name, value|
        expect(resource.send(attr_name)).to_not eq value
      end
    end

    it 'returns forbidden status' do
       patch_update

       expect(response).to have_http_status(:forbidden)
    end
  end
end
