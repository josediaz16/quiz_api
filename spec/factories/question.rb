FactoryBot.define do
  factory :question do
    description 'What day is it?'
    options ['sunday', 'monday', 'tuesday']
    answer 'sunday'
  end
end
