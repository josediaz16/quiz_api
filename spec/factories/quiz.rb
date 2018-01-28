FactoryBot.define do
  factory :quiz do
    name { Faker::Friends.quote }
    category "Tv Show"
    questions { build_list :question, Quiz::NUMBER_OF_QUESTIONS[:test] }
  end
end
