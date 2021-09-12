class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    save_and_render(@question)
  end

  def update
    @question.update(question_params)
    save_and_render(@question)
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url])
  end
end
