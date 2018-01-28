class Quizzes::Answer
  attr_reader :error, :question_id, :submitted_answer

  def initialize(answer)
    @question_id = answer[:id]
    @submitted_answer = answer[:answer]
  end

  def valid?
    if question.present?
      true
    else
      @error = Response.error(:question_not_found) { "The question with identifier #{question_id} could not be found" }
      false
    end
  end

  def question
    @question ||= Question.find_by(id: question_id)
  end

  def correct?
    question.answer.downcase.eql?(submitted_answer.downcase)
  end
end
