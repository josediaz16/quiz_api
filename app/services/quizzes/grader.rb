class Quizzes::Grader
  def initialize(quiz, answers)
    @quiz = quiz
    @answers = set_answers(answers)
  end

  def perform
    if complete_quiz?
      builder.new_graded_quiz

      @answers.each do |answer|
        return answer.error if not answer.valid?
        builder.add_answer(answer)
      end
      builder.save
    else
      Response.error(:invalid_number_of_answers) { "The number of answers does not match the number of questions of the quiz" }
    end
  end

  private

  def set_answers(answers)
    answers.map { |answer| Quizzes::Answer.new(answer) }
  end

  def complete_quiz?
    @quiz.questions.count.eql?(@answers.count)
  end

  def builder
    @builder ||= Quizzes::GradedQuizBuilder.new(@quiz.id)
  end
end
