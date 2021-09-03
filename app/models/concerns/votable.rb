module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:status)
  end

  def vote_of(user)
    votes.find_by(author: user)
  end
end
