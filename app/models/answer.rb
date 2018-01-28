class Answer < ApplicationRecord
  belongs_to :graded_quiz
  belongs_to :question
end
