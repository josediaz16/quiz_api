class GradedQuizzesController < ApplicationController
  def create
    quiz = Quiz.find(params[:quiz_id])
    response = Quizzes::Grader.new(quiz, quiz_params[:questions_attributes]).perform

    if response.success?
      render json: response.data, status: 201
    else
      render json: {error: response.parsed_errors }, status: 400
    end
  end

  def show
    graded_quiz = Quiz.find(params[:quiz_id]).graded_quizzes.find(params[:id])
    render json: graded_quiz, include: :answers
  end

  private

  def quiz_params
    params.require(:quiz).permit(questions_attributes: [:id, :answer])
  end
end
