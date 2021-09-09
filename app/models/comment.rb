class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  def question
    case commentable_type
    when 'Question'
      commentable
    when 'Answer'
      commentable.question
    end
  end
end
