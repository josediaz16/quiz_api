# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180127200707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", id: :serial, force: :cascade do |t|
    t.string "description", null: false
    t.boolean "correct"
    t.integer "question_id"
    t.integer "graded_quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["graded_quiz_id"], name: "index_answers_on_graded_quiz_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "graded_quizzes", id: :serial, force: :cascade do |t|
    t.string "author", default: "anonymous", null: false
    t.decimal "score", default: "0.0", null: false
    t.integer "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_graded_quizzes_on_quiz_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.text "description", null: false
    t.jsonb "options", null: false
    t.string "answer", null: false
    t.integer "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "category", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "graded_quizzes"
  add_foreign_key "answers", "questions"
  add_foreign_key "graded_quizzes", "quizzes"
  add_foreign_key "questions", "quizzes"
end
