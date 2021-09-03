describe VotesController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { author: user, votable_type: 'Question', votable_id: question.id, status: vote_params }, format: :json }

    context 'with valid attributes' do
      let(:vote_params) { :upvote }

      it 'bonds a new vote with the voter' do
        expect { post_create }.to change(user.votes, :count).by(1)
      end

      it 'bonds a new vote with the votable' do
        expect { post_create }.to change(question.votes, :count).by(1)
      end

      it 'saves a new vote in the database' do
        expect { post_create }.to change(Vote, :count).by(1)
      end

      it 'returns json' do
        post_create

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['rating']).to be_present
        expect(json_response['vote']).to be_present
      end
    end

    context 'with invalid attributes' do
      let(:vote_params) { nil }

      it 'does not save the vote' do
        expect { post_create }.to_not change(Vote, :count)
      end

      it 'returns unprocessable_entity status' do
        post_create

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is author of votable' do
      let(:vote_params) { :upvote }
      let!(:question) { create(:question, author: user) }

      it 'does not save the vote' do
        expect { post_create }.to_not change(Vote, :count)
      end

      it 'returns forbidden status' do
        post_create

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user already voted' do
      let(:vote_params) { :upvote }
      let!(:vote) { create(:vote, author: user, votable: question) }

      it 'does not save the vote' do
        expect { post_create }.to_not change(Vote, :count)
      end

      it 'returns forbidden status' do
        post_create

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: vote }, format: :json }

    context 'user is the voter' do
      let!(:vote) { create(:vote, author: user) }

      it 'deletes the vote' do
        expect { delete_destroy }.to change(Vote, :count).by(-1)
      end

      it 'returns json' do
        delete_destroy
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['rating']).to be_present
        expect(json_response['vote']).to be_present
      end
    end

    context 'user is not the voter' do
      let!(:vote) { create(:vote) }

      it 'does not delete the vote' do
        expect { delete_destroy }.to_not change(Vote, :count)
      end

      it 'returns forbidden status' do
        delete_destroy

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
