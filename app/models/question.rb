class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_author

  def subscription_of(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscribe_author
    subscriptions.create(user: author)
  end
end
