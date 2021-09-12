describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Indexable' do
      let!(:resources) { create_list(:answer, 3, question: question) }
      let(:resources_response) { json['answers'] }
      let(:public_fields) { %w[id body author_id created_at updated_at] }
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, files: [fixture_file_upload('spec/rails_helper.rb'),
                                           fixture_file_upload('spec/spec_helper.rb')]) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Showable' do
      let(:resource) { answer }
      let(:resource_response) { json['answer'] }
      let(:public_fields) { %w[id body author_id created_at updated_at] }
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable' do
      let(:resource_class) { Answer }
      let(:resource_name) { :question }
      let(:valid_attributes) { { answer: attributes_for(:answer) } }
      let(:invalid_attributes) { { answer: attributes_for(:answer, :invalid) } }
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Updatable' do
      let(:resource) { answer }
      let(:resource_name) { :answer }
      let(:valid_attributes) { { answer: { body: 'API Body' } } }
      let(:invalid_attributes) { { answer: { body: '' } } }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Destroyable' do
      let(:resource) { answer }
    end
  end
end
