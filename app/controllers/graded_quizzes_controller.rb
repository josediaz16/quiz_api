class GradedQuizzesController < ApplicationController
  def show
    graded_quiz = Quiz.find(params[:quiz_id]).graded_quizzes.find(params[:id])
    render json: graded_quiz, include: :answers
  end
end
