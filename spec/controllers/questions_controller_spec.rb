describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question: question_params } }

    before { login(user) }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it 'bonds a new question with the author' do
        expect { post_create }.to change(user.questions, :count).by(1)
      end

      it 'saves a new question in the database' do
        expect { post_create }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post_create
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'does not save the question' do
        expect { post_create }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: question, question: question_params }, format: :js }

    before { login(user) }

    context 'with valid attributes' do
      let!(:question) { create(:question, author: user) }
      let(:question_params) { { title: 'new title', body: 'new body' } }

      it 'changes question attributes' do
        patch_update
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:question) { create(:question, author: user, title: 'some title') }
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'does not change question attributes' do
        patch_update
        question.reload

        expect(question.title).to eq 'some title'
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'user is not the author' do
      let!(:question) { create(:question) }
      let(:question_params) { { body: 'new body' } }

      it 'does not change question attributes' do
        patch_update
        question.reload

        expect(question.body).to_not eq 'new body'
      end

      it 'renders update view' do
         patch_update

         expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: question } }

    before { login(user) }

    context 'user is the author' do
      let!(:question) { create(:question, author: user) }

      it 'deletes the question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not the author' do
      let!(:question) { create(:question) }

      it 'does not delete the question' do
        expect { delete_destroy }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #choose_best_answer' do
    let(:patch_choose_best_answer) { patch :choose_best_answer, params: { id: question, answer_id: answer }, format: :js }

    let(:answer) { create(:answer, question: question) }

    before { login(user) }

    context 'user is the author' do
      let(:question) { create(:question, author: user) }

      it "changes questions's best answer" do
        patch_choose_best_answer
        question.reload

        expect(question.best_answer).to eq answer
      end

      it "renders choose best answer view" do
        patch_choose_best_answer

        expect(response).to render_template :choose_best_answer
      end
    end

    context 'user is not the author' do
      let(:question) { create(:question) }

      it "does not change questions's best answer" do
        patch_choose_best_answer
        question.reload

        expect(question.best_answer).to eq nil
      end

      it "renders choose best answer view" do
        patch_choose_best_answer

        expect(response).to render_template :choose_best_answer
      end
    end
  end

  describe 'DELETE #destroy_file' do
    let(:delete_destroy_file) { delete :destroy_file, params: { id: question, file_id: question.files.first }, format: :js }

    before do
      login(user)

      delete_destroy_file
    end

    context 'user is the author' do
      let!(:question) { create(:question, author: user, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'deletes the question file' do
        expect(question.reload.files).to_not be_attached
      end

      it 'renders destroy file view' do
        expect(response).to render_template :destroy_file
      end
    end

    context 'user is not the author' do
      let!(:question) { create(:question, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'does not delete the question file' do
        expect(question.reload.files).to be_attached
      end

      it 'renders destroy file view' do
        expect(response).to render_template :destroy_file
      end
    end
  end
end
