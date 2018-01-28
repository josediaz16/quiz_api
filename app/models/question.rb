class Question < ApplicationRecord
  belongs_to :quiz
  validates :description, :answer, presence: true
end
