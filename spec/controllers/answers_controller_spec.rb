describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }

    before { login(user) }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'bonds a new answer with the question' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the database' do
        expect { post_create }.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do
        post_create
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
