shared_examples_for 'API Indexable' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:resource) { resources.first }
    let(:resource_response) { resources_response.first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns list of resources' do
      expect(resources_response.size).to eq resources.size
    end

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(resource_response[attr]).to eq resource.send(attr).as_json
      end
    end

    it 'returns successful status' do
      expect(response).to be_successful
    end
  end
end
