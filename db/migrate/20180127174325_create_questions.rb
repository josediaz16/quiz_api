class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :description, null: false
      t.jsonb :options, null: false
      t.string :answer, null: false
      t.references :quiz, foreign_key: true
    end
  end
end
