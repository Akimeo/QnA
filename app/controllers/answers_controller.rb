class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  def destroy_file
    if current_user.author_of?(answer)
      file.purge
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def file
    @file ||= ActiveStorage::Attachment.find(params[:file_id])
  end

  helper_method :question, :answer, :file

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
