class AnswerSerializer < ActiveModel::Serializer
  attributes :description, :created_at
  attribute :question do
    object.question.description
  end
  belongs_to :graded_quiz
  type :answer
end
