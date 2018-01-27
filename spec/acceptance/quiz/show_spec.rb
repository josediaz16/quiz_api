require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe QuizzesController, type: :request do
  before { Timecop.freeze(2018, 1, 27, 12) }
  after { Timecop.return }

  resource "Quizzes" do
    let(:quiz) { Quiz.create(name: "Friends trivia", category: "TV show") }
    let(:question_1) { Question.create(quiz: quiz, description: "Name of Monica's brother", options: ['Chandler', 'Ross', 'Joey', 'Mike'], answer: "Ross") }
    let(:question_2) { Question.create(quiz: quiz, description: "Who says vafanapoli?", options: ['Rachel', 'Monica', 'Joey', 'Mike'], answer: "Joey") }
    let(:question_3) { Question.create(quiz: quiz, description: "How many sisters does Joey have?", options: ['7', '3', '4', '0'], answer: "7") }
    let(:question_4) { Question.create(quiz: quiz, description: "Almost beat pacman's record", options: ['Jack', 'Ben', 'Gunther', 'Phoebe'], answer: "Phoebe") }
    let(:question_5) { Question.create(quiz: quiz, description: "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'", options: ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'], answer: "Chandler") }

    let(:id) { quiz.id }

    header "Accept", "application/json"

    get "quizzes/:id" do
      example "Retrieving a quiz" do
        expected_response = {
          "data" => {
            "id" => quiz.id.to_s,
            "type" => "quiz",
            "attributes" => {
              "name" => "Friends trivia",
              "category" => "TV show",
              "created-at" => "2018-01-27T12:00:00.000Z",
              "updated-at" => "2018-01-27T12:00:00.000Z"
            },
            "links" => {
              "self" => {"href" => "/quizzes/#{quiz.id}"}
            },
            "relationships" => {
              "questions" => {
                "data" => [
                  {"id" => question_1.id.to_s, "type" => "question"},
                  {"id" => question_2.id.to_s, "type" => "question"},
                  {"id" => question_3.id.to_s, "type" => "question"},
                  {"id" => question_4.id.to_s, "type" => "question"},
                  {"id" => question_5.id.to_s, "type" => "question"}
                ]
              }
            }
          },
          "included" => [
            {
              "id" => question_1.id.to_s,
              "type" => "question",
              "attributes" => {
                "description" => "Name of Monica's brother",
                "options" => ['Chandler', 'Ross', 'Joey', 'Mike'],
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "relationships" => {
                "quiz" => {
                  "data" => {
                    "id" => quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz.id}/questions/#{question_1.id}"}
              }
            },
            {
              "id" => question_2.id.to_s,
              "type" => "question",
              "attributes" => {
                "description" => "Who says vafanapoli?",
                "options" => ['Rachel', 'Monica', 'Joey', 'Mike'],
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "relationships" => {
                "quiz" => {
                  "data" => {
                    "id" => quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz.id}/questions/#{question_2.id}"}
              }
            },
            {
              "id" => question_3.id.to_s,
              "type" => "question",
              "attributes" => {
                "description" => "How many sisters does Joey have?",
                "options" => ['7', '3', '4', '0'],
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "relationships" => {
                "quiz" => {
                  "data" => {
                    "id" => quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz.id}/questions/#{question_3.id}"}
              }
            },
            {
              "id" => question_4.id.to_s,
              "type" => "question",
              "attributes" => {
                "description" => "Almost beat pacman's record",
                "options" => ['Jack', 'Ben', 'Gunther', 'Phoebe'],
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "relationships" => {
                "quiz" => {
                  "data" => {
                    "id" => quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz.id}/questions/#{question_4.id}"}
              }
            },
            {
              "id" => question_5.id.to_s,
              "type" => "question",
              "attributes" => {
                "description" => "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'",
                "options" => ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'],
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "relationships" => {
                "quiz" => {
                  "data" => {
                    "id" => quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz.id}/questions/#{question_5.id}"}
              }
            }
          ]
        }
        do_request
        response = JSON.parse(response_body)
        expect(response).to eq expected_response
      end
    end
  end
  context "The quiz does not exists" do
    example "Should return 404" do
      get '/quizzes/1'
      expect(response.status).to eq(404)
      expect(response.body).to eq("404 not found")
    end
  end
end
