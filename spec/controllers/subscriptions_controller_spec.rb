describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question }, format: :js }

    context 'when not subscribed yet' do

      it 'bonds a new subscription with the user' do
        expect { post_create }.to change(user.subscriptions, :count).by(1)
      end

      it 'bonds a new subscription with the question' do
        expect { post_create }.to change(question.subscriptions, :count).by(1)
      end

      it 'saves a new subscription in the database' do
        expect { post_create }.to change(Subscription, :count).by(2)
      end

      it 'renders create view' do
        post_create

        expect(response).to render_template :create
      end
    end

    context 'when already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'does not save the subscription' do
        expect { post_create }.to_not change(Subscription, :count)
      end

      it 'returns forbidden status' do
        post_create

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: subscription }, format: :js }

    context 'user is the subscriber' do
      let!(:subscription) { create(:subscription, user: user) }

      it 'deletes the subscription' do
        expect { delete_destroy }.to change(Subscription, :count).by(-1)
      end

      it 'renders destroy view' do
        delete_destroy

        expect(response).to render_template :destroy
      end
    end

    context 'user is not the subscriber' do
      let!(:subscription) { create(:subscription) }

      it 'does not delete the subscription' do
        expect { delete_destroy }.to_not change(Subscription, :count)
      end

      it 'returns forbidden status' do
        delete_destroy

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
