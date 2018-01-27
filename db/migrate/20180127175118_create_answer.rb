class CreateAnswer < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :description, null: false
      t.boolean :correct
      t.references :question, foreign_key: true
      t.references :graded_quiz, foreign_key: true
    end
  end
end
