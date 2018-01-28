class GradedQuizSerializer < ActiveModel::Serializer
  attributes :id, :author, :score, :created_at, :updated_at

  has_many :answers do
    object.answers.where(correct: false)
  end

  type :graded_quiz

  link :self do
    href quiz_graded_quiz_path(object.quiz.id, object)
  end
end
