class QuizzesController < ApplicationController
  def index
    render json: Quiz.all, exclude_questions: true
  end

  def show
    quiz = Quiz.find(params[:id])
    render json: quiz, include: :questions
  end
end
