class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  load_and_authorize_resource

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    if answer.persisted?
      answer_partial = ApplicationController.render(
        partial: 'answers/sub_answer',
        locals: { answer: answer }
      )
      data = { answer: answer_partial, user_id: current_user.id, question_author_id: answer.question.author.id }
      AnswersChannel.broadcast_to(question, data)
    end
  end
end
