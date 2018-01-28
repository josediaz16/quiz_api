class Quiz < ApplicationRecord
  has_many :questions
  has_many :graded_quizzes
  validates :name, :questions, presence: true

  accepts_nested_attributes_for :questions
end
