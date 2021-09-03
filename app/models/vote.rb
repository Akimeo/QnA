class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :status, presence: true

  enum status: { not_yet: 0, upvote: 1, downvote: -1 }
end
