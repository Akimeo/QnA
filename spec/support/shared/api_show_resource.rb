shared_examples_for 'API Showable' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let!(:comments) { create_list(:comment, 3, commentable: resource) }
    let!(:links) { create_list(:link, 2, linkable: resource)}

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(resource_response[attr]).to eq resource.send(attr).as_json
      end
    end

    it 'returns successful status' do
      expect(response).to be_successful
    end

    describe 'comments' do
      let(:comment) { comments.first }
      let(:comment_response) { resource_response['comments'].first }

      it 'returns list of comments' do
        expect(resource_response['comments'].size).to eq comments.size
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end

    describe 'files' do
      let(:file) { resource.files.first }
      let(:file_response) { resource_response['files'].first }

      it 'returns list of files' do
        expect(resource_response['files'].size).to eq resource.files.size
      end

      it 'returns file url' do
        expect(file_response['url']).to include file.filename.to_s
      end
    end

    describe 'links' do
      let(:link) { links.first }
      let(:link_response) { resource_response['links'].first }

      it 'returns list of links' do
        expect(resource_response['links'].size).to eq links.size
      end

      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end
    end
  end
end
