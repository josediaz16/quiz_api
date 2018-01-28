Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :quizzes, only: [:index, :show, :create, :update] do
    post :grade
    resources :questions, only: :show
    resources :graded_quizzes, only: :show
  end
end
