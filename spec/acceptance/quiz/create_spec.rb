require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe QuizzesController, type: :request do
  resource "Quizzes" do
    header 'Content-Type', "application/json"

    with_options scope: :quiz do
      parameter :name, "Quiz Name", required: true
      parameter :category, "Quiz Category", required: false
      parameter :questions_attributes, "A set of 20 questions, for detailed documentation of each field of question, see below", required: true
    end

    with_options scope: [:quiz, :questions_attributes], required: true do
      parameter :description, "The question itself"
      parameter :options, "An array of possible answers"
      parameter :answer, "The correct answer from the options set"
    end

    let(:name) { "Friends Trivia" }
    let(:category) { "TV show" }
    let(:questions_attributes) do
      [
        {
          "description" => "Name of Monica's brother",
          "options" => ['Chandler', 'Ross', 'Joey', 'Mike'],
          "answer" => "Ross"
        },
        {
          "description" => "Who says vafanapoli?",
          "options" => ['Rachel', 'Monica', 'Joey', 'Mike'],
          "answer" => 'Joey'
        },
        {
          "description" => "How many sisters does Joey have?",
          "options" => ['7', '3', '4', '0'],
          "answer" => '7'
        },
        {
          "description" => "Almost beat pacman's record",
          "options" => ['Jack', 'Ben', 'Gunther', 'Phoebe'],
          "answer" => "Phoebe"
        },
        {
          "description" => "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'",
          "options" => ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'],
          "answer" => "Chandler"
        }
      ]
    end

    post "/quizzes" do
      context "A successful request" do
        let(:raw_post) { params.to_json }

        example "Creating a quiz" do
          expect(params).to eq({
            "quiz"=> {
              "name"=>"Friends Trivia",
              "category"=>"TV show",
              "questions_attributes"=> [
                {
                  "description"=>"Name of Monica's brother",
                  "options"=>["Chandler", "Ross", "Joey", "Mike"],
                  "answer"=>"Ross"
                },
                {
                  "description"=>"Who says vafanapoli?",
                  "options"=>["Rachel", "Monica", "Joey", "Mike"],
                  "answer"=>"Joey"
                },
                {
                  "description"=>"How many sisters does Joey have?",
                  "options"=>["7", "3", "4", "0"],
                  "answer"=>"7"
                },
                {
                  "description"=>"Almost beat pacman's record",
                  "options"=>["Jack", "Ben", "Gunther", "Phoebe"],
                  "answer"=>"Phoebe"
                },
                {
                  "description"=>
                  "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'",
                  "options"=>["Chandler", "Rachel", "Joey", "Frankie Jr"],
                  "answer"=>"Chandler"
                }
              ]
            }
          })

          do_request

          quiz = Quiz.last

          expect(status).to eq(201)
          response = JSON.parse(response_body)
          expect(response). to eq({"id" => quiz.id})
        end
      end

      context "Sending a blank name" do
        let!(:name) { "" }
        let(:raw_post) { params.to_json }

        example "Should respond 400", document: false do
          do_request

          quiz = Quiz.last

          expect(status).to eq(400)
          expect(quiz).to be_nil

          response = JSON.parse(response_body)
          expect(response).to eq({
            "error" => {
              "name" => ["can't be blank"]
            }
          })
        end
      end
      context "Sending an empty array of questions" do
        let!(:questions_attributes) { [] }
        let(:raw_post) { params.to_json }

        example "Should respond 400", document: false do
          do_request

          quiz = Quiz.last

          expect(status).to eq(400)
          expect(quiz).to be_nil

          response = JSON.parse(response_body)
          expect(response).to eq({
            "error" => {
              "questions" => ["can't be blank"]
            }
          })
        end
      end
      context "Sending a question without answer" do
        before { questions_attributes[0].delete("answer") }
        let(:raw_post) { params.to_json }

        example "Should respond 400", document: false do
          do_request

          quiz = Quiz.last

          expect(status).to eq(400)
          expect(quiz).to be_nil

          response = JSON.parse(response_body)
          expect(response).to eq({
            "error" => {
              "questions.answer" => ["can't be blank"]
            }
          })
        end
      end
    end
  end
end
