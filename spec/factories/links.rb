FactoryBot.define do
  factory :link do
    name { 'Link Name' }
    url { 'https://www.google.com/' }
    association :linkable, factory: :question

    trait :gist do
      url { 'https://gist.github.com/Akimeo/f76accba429d1759f0db4f684706a13a' }
    end
  end
end
