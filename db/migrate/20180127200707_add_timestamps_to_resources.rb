class AddTimestampsToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :created_at, :datetime, null: false
    add_column :quizzes, :updated_at, :datetime, null: false
    add_column :questions, :created_at, :datetime, null: false
    add_column :questions, :updated_at, :datetime, null: false
    add_column :graded_quizzes, :created_at, :datetime, null: false
    add_column :graded_quizzes, :updated_at, :datetime, null: false
    add_column :answers, :created_at, :datetime, null: false
    add_column :answers, :updated_at, :datetime, null: false
  end
end
