shared_examples_for 'API Authorizable' do
  context 'when unauthorized' do
    it 'returns unauthorized status if there is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response).to be_unauthorized
    end

    it 'returns unauthorized status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: 'iamwrong' }, headers: headers)

      expect(response).to be_unauthorized
    end
  end
end
