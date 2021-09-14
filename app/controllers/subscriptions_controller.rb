class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create_subscription, question

    @subscription = current_user.subscriptions.create(question: question)
  end

  def destroy
    authorize! :destroy, subscription

    subscription.destroy
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : subscription.question
  end

  def subscription
    @subscription ||= params[:id] ? Subscription.find(params[:id]) : Subscription.new
  end

  helper_method :question, :subscription
end
