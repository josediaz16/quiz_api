class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :description, :options, :created_at, :updated_at
  belongs_to :quiz
  type :question

  link :self do
    href quiz_question_path(object.quiz.id, object.id)
  end
end
