class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  load_and_authorize_resource

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = commentable
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable
    @commentable ||= params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end

  def comment
    @comment ||= Comment.find(params[:id])
  end

  helper_method :comment

  def publish_comment
    if comment.persisted?
      comment_partial = ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: comment }
      )
      data = {
        comment: comment_partial,
        user_id: current_user.id,
        commentable_type: comment.commentable_type,
        commentable_id: comment.commentable_id
      }
      CommentsChannel.broadcast_to(comment.question, data)
    end
  end
end
