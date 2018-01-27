class CreateQuiz < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.string :name, null: false
      t.string :category, null: false, default: ""
    end
  end
end
