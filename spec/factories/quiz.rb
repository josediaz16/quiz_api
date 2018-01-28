FactoryBot.define do
  factory :quiz do
    name { Faker::Friends.quote }
    category "Tv Show"
    questions { build_list :question, 1 }
  end
end
