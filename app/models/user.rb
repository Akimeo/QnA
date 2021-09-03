class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :awards, dependent: :nullify
  has_many :votes, dependent: :destroy

  def author_of?(resource)
    id == resource.author_id
  end
end
