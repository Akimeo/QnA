describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Indexable' do
      let!(:resources) { create_list(:question, 3) }
      let(:resources_response) { json['questions'] }
      let(:public_fields) { %w[id title body author_id created_at updated_at] }
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, files: [fixture_file_upload('spec/rails_helper.rb'),
                                               fixture_file_upload('spec/spec_helper.rb')]) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Showable' do
      let(:resource) { question }
      let(:resource_response) { json['question'] }
      let(:public_fields) { %w[id title body author_id created_at updated_at] }
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable' do
      let(:resource_class) { Question }
      let(:resource_name) { :question }
      let(:valid_attributes) { { question: attributes_for(:question) } }
      let(:invalid_attributes) { { question: attributes_for(:question, :invalid) } }
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Updatable' do
      let(:resource) { question }
      let(:resource_name) { :question }
      let(:valid_attributes) { { question: { title: 'API Title', body: 'API Body' } } }
      let(:invalid_attributes) { { question: { title: '', body: 'API Body' } } }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Destroyable' do
      let(:resource) { question }
    end
  end
end
