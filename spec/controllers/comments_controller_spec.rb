describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { commentable_type: 'Question', commentable_id: question.id, comment: comment_params }, format: :js }

    context 'with valid attributes' do
      let(:comment_params) { attributes_for(:comment) }

      it 'bonds a new comment with the author' do
        expect { post_create }.to change(user.comments, :count).by(1)
      end

      it 'bonds a new comment with the commentable' do
        expect { post_create }.to change(question.comments, :count).by(1)
      end

      it 'saves a new comment in the database' do
        expect { post_create }.to change(Comment, :count).by(1)
      end

      it 'renders create view' do
        post_create
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:comment_params) { attributes_for(:comment, :invalid) }

      it 'does not save the comment' do
        expect { post_create }.to_not change(Comment, :count)
      end

      it 'renders create view' do
        post_create
        expect(response).to render_template :create
      end
    end
  end
end
