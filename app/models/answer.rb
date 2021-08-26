class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  before_destroy :nullify_best, if: :best?

  def best?
    id == question.best_answer_id
  end

  private

  def nullify_best
    question.update(best_answer: nil)
  end
end
