class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
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
    if current_user.author_of?(question)
      question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    else
      flash[:alert] = 'You must be the author to delete the question.'
    end

    redirect_to questions_path
  end

  def choose_best_answer
    if current_user.author_of?(question)
      @previous_best_answer = question.best_answer
      question.update(best_answer: answer)
    end
  end

  private

  def question
    if params[:id]
      @question ||= Question.with_attached_files.find(params[:id])
    else
      @question ||= Question.new
      @question.links.build if @question.links.empty?
      @question
    end
  end

  def answer
    if params[:answer_id]
      @answer ||= Answer.with_attached_files.find(params[:answer_id])
    else
      @answer ||= Answer.new
      @answer.links.build if @answer.links.empty?
      @answer
    end
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
