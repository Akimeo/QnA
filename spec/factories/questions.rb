FactoryBot.define do
  sequence :title do |n|
    "Test #{n} Title"
  end

  sequence :body do |n|
    "Test #{n} Body"
  end

  factory :question do
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
