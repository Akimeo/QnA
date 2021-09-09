FactoryBot.define do
  factory :comment do
    body { 'Comment Body' }
    association :author, factory: :user
    association :commentable, factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
