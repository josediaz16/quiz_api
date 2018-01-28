class Quizzes::GradedQuizBuilder

  def initialize(quiz_id)
    @quiz_id = quiz_id
    @correct_answers = 0
  end

  def new_graded_quiz
    @graded_quiz = GradedQuiz.new(quiz_id: @quiz_id)
  end

  def add_answer(answer)
    @correct_answers += 1 if answer.correct?
    @graded_quiz.answers.build(question_id: answer.question_id, description: answer.submitted_answer, correct: answer.correct?)
  end

  def save
    @graded_quiz.score = score
    @graded_quiz.save
    Response.success(data: {id: @graded_quiz.id, score: @graded_quiz.score})
  end

  private

  def score
    (@correct_answers / @graded_quiz.answers.length.to_f ) * 10
  end
end
