class QuizSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :created_at, :updated_at
  has_many :questions, :unless => :exclude_questions?
  type :quiz

  link :self do
    href quiz_path(object)
  end

  def exclude_questions?
    instance_options[:exclude_questions] || false
  end
end
