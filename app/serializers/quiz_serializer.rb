class QuizSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :category, :created_at, :updated_at
  type :quiz

  link :self do
    href quiz_path(object)
  end
end
