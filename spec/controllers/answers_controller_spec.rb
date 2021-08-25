describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }

    before { login(user) }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'bonds a new answer with the author' do
        expect { post_create }.to change(user.answers, :count).by(1)
      end

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

      it 're-renders question show view' do
        post_create
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer } }

    before { login(user) }

    context 'user is the author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete_destroy
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'user is not the author' do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        delete_destroy
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
