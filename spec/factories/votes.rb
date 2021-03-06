FactoryBot.define do
  factory :vote do
    status { 1 }
    association :author, factory: :user
    association :votable, factory: :question

    trait :invalid do
      status { nil }
    end
  end
end
