class QuizzesController < ApplicationController
  def index
    render json: Quiz.all, exclude_questions: true
  end

  def show
    quiz = Quiz.find(params[:id])
    render json: quiz, include: :questions
  end

  def create
    quiz = Quiz.new(quiz_params)
    if quiz.save
      render json: {id: quiz.id}, status: 201
    else
      render json: {error: quiz.errors.messages}, status: 400
    end
  end

  def update
    quiz = Quiz.find(params[:id])
    if quiz.update(quiz_params)
      render json: {id: quiz.id}
    else
      render json: {error: quiz.errors.messages}, status: 400
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:name, :category, questions_attributes: [:id, :description, :answer, options: []])
  end
end
