class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: :create

  load_and_authorize_resource

  def index
    @questions = Question.all
  end

  def show
    answer.links.build
    gon.user_id = current_user&.id
  end

  def new
    question.links.build
    question.build_award
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    flash[:notice] = 'Your question was successfully deleted.'

    redirect_to questions_path
  end

  def choose_best_answer
    @previous_best_answer = question.best_answer
    question.transaction do
      question.update!(best_answer: answer)
      question.award&.update!(user: answer.author)
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= params[:answer_id] ? Answer.with_attached_files.find(params[:answer_id]) : Answer.new
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], award_attributes: [:title, :image])
  end

  def publish_question
    if question.persisted?
      ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/sub_question',
          locals: { question: question }
        )
      )
    end
  end
end
