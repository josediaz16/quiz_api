class CreateGradedQuiz < ActiveRecord::Migration[5.0]
  def change
    create_table :graded_quizzes do |t|
      t.string :author, null: false, default: 'anonymous'
      t.decimal :score, null: false, default: 0.0
      t.references :quiz, foreign_key: true
    end
  end
end
