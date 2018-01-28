class Quiz < ApplicationRecord
  # This value is lower in test env to make test and documentation more readable.
  # It can be changed to update the docs.
  NUMBER_OF_QUESTIONS = { development: 5, production: 20, test: 5 }

  has_many :questions
  has_many :graded_quizzes
  validates :name, presence: true
  validate :valid_questions?

  accepts_nested_attributes_for :questions

  def valid_questions?
    number_of_questions = NUMBER_OF_QUESTIONS[Rails.env.to_sym]

    if not (questions.present? && questions.length.eql?(number_of_questions))
      errors.add(:questions, :invalid_number_of_questions, message: "There must be #{number_of_questions} questions")
    end
  end
end
