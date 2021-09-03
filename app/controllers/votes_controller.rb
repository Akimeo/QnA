class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = current_user.votes.new(status: params[:status])
    @vote.votable = votable

    return head :forbidden if current_user.author_of?(votable) || votable.vote_of(current_user)

    if @vote.save
      render json: { vote: @vote, rating: votable.rating }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden if current_user != vote.user

    vote.destroy
    render json: { vote: vote, rating: vote.votable.rating }
  end

  private

  def votable
    @votable ||= params[:votable_type].classify.constantize.find(params[:votable_id])
  end

  def vote
    @vote ||= Vote.find(params[:id])
  end
end
