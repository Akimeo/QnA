describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let!(:users) { create_list(:user, 3) }
      let(:users_ids) { users.map(&:id).sort }
      let(:response_users) { json['users'] }
      let(:response_users_ids) { response_users.map { |user| user['id'] }.sort }

      let(:user) { users.first }
      let(:response_user) { response_users.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of users' do
        expect(response_users.size).to eq users.size
      end

      it 'returns all users except me' do
        expect(response_users_ids).to eq users_ids
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
            expect(response_user[attr]).to eq user.send(attr).as_json
          end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
            expect(response_user).to_not have_key(attr)
          end
      end

      it 'returns successful status' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:response_user) { json['user'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
            expect(response_user[attr]).to eq me.send(attr).as_json
          end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
            expect(response_user).to_not have_key(attr)
          end
      end

      it 'returns successful status' do
        expect(response).to be_successful
      end
    end
  end
end
