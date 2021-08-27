describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params }, format: :js }

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

      it 'renders create view' do
        post_create
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post_create
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

    context 'with valid attributes' do
      let!(:answer) { create(:answer, author: user) }
      let(:answer_params) { { body: 'new body' } }

      it 'changes answer attributes' do
        patch_update
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:answer) { create(:answer, author: user, body: 'some body') }
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not change answer attributes' do
        patch_update
        answer.reload

        expect(answer.body).to eq 'some body'
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'user is not the author' do
      let!(:answer) { create(:answer) }
      let(:answer_params) { { body: 'new body' } }

      it 'does not change answer attributes' do
        patch_update
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'renders update view' do
         patch_update

         expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer }, format: :js }

    context 'user is the author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete_destroy

        expect(response).to render_template :destroy
      end
    end

    context 'user is not the author' do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect { delete_destroy }.to_not change(Answer, :count)
      end

      it 'renders destroy view' do
        delete_destroy

        expect(response).to render_template :destroy
      end
    end
  end

  describe 'DELETE #destroy_file' do
    let(:delete_destroy_file) { delete :destroy_file, params: { id: answer, file_id: answer.files.first }, format: :js }

    before do
      login(user)

      delete_destroy_file
    end

    context 'user is the author' do
      let!(:answer) { create(:answer, author: user, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'deletes the answer file' do
        expect(answer.reload.files).to_not be_attached
      end

      it 'renders destroy file view' do
        expect(response).to render_template :destroy_file
      end
    end

    context 'user is not the author' do
      let!(:answer) { create(:answer, files: [fixture_file_upload('spec/rails_helper.rb')]) }

      it 'does not delete the answer file' do
        expect(answer.reload.files).to be_attached
      end

      it 'renders destroy file view' do
        expect(response).to render_template :destroy_file
      end
    end
  end
end
