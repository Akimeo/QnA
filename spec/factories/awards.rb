FactoryBot.define do
  factory :award do
    title { 'Award Title' }
    image { Rack::Test::UploadedFile.new('public/leg.png', 'image/png') }
    question
  end
end
