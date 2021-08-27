class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
