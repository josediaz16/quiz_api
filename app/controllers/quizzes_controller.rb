class QuizzesController < ApplicationController
  def index
    render json: Quiz.all
  end
end
