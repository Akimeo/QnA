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
    before { get :show, params: { id: question } }

    it 'builds answer links' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)

      get :new
    end

    it 'builds question links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'builds question award' do
      expect(assigns(:question).award).to be_a_new(Award)
    end

    it 'renders new view' do
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

      it 'returns forbidden status' do
        patch_update

        expect(response).to have_http_status(:forbidden)
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

      it 'redirects to root url' do
        delete_destroy

        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'PATCH #choose_best_answer' do
    let(:patch_choose_best_answer) { patch :choose_best_answer, params: { id: question, answer_id: answer }, format: :js }

    let(:answer_author) { create(:user) }
    let(:answer) { create(:answer, question: question, author: answer_author) }

    before { login(user) }

    context 'user is the author' do
      let(:question) { create(:question, author: user) }
      let!(:award) { create(:award, question: question) }

      it "changes questions's best answer" do
        patch_choose_best_answer
        question.reload

        expect(question.best_answer).to eq answer
      end

      it "changes question award's user" do
        patch_choose_best_answer
        award.reload

        expect(award.user).to eq answer_author
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

      it 'returns forbidden status' do
        patch_choose_best_answer

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
