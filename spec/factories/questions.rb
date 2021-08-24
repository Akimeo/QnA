FactoryBot.define do
  sequence :title do |n|
    "Question #{n} Title"
  end

  sequence :body do |n|
    "Question #{n} Body"
  end

  factory :question do
    association :author, factory: :user
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
