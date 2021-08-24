class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer was successfully posted.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    else
      flash[:alert] = 'You must be the author to delete the answer.'
    end

    redirect_to question_path(answer.question)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
