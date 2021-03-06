FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question
    body { 'Answer Body' }

    trait :invalid do
      body { nil }
    end
  end
end
