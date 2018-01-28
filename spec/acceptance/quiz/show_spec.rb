require 'support/acceptance_helper'

RSpec.describe QuizzesController, type: :request do
  before { Timecop.freeze(2018, 1, 27, 12) }
  after { Timecop.return }

  resource "Quizzes" do
    before do
      @quiz = Quiz.new(name: "Friends trivia", category: "TV show")
      @question_1 = @quiz.questions.build(description: "Name of Monica's brother", options: ['Chandler', 'Ross', 'Joey', 'Mike'], answer: "Ross")
      @question_2 = @quiz.questions.build(description: "Who says vafanapoli?", options: ['Rachel', 'Monica', 'Joey', 'Mike'], answer: "Joey")
      @question_3 = @quiz.questions.build(description: "How many sisters does Joey have?", options: ['7', '3', '4', '0'], answer: "7")
      @question_4 = @quiz.questions.build(description: "Almost beat pacman's record", options: ['Jack', 'Ben', 'Gunther', 'Phoebe'], answer: "Phoebe")
      @question_5 = @quiz.questions.build(description: "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'", options: ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'], answer: "Chandler")
      @quiz.save
    end

    let(:id) { @quiz.id }

    header "Accept", "application/json"

    with_options scope: :data do
      response_field :id, "The unique identifier of the quiz."
      response_field :type, "The type of object in the API."
    end

    with_options scope: [:data, :attributes] do
      response_field :name, "The name of the quiz."
      response_field :category, "The category of the quiz."
      response_field "created-at", "The date and time the quiz was created."
      response_field "updated-at", "The last date and time the quiz was update."
    end

    with_options scope: [:data, :relationships, :questions] do
      response_field :data, "The set of identifiers of questions of the quiz."
    end

    response_field :included, "Detailed data about each question of the quiz."

    with_options scope: :included do
      response_field :id, "The unique identifier of the question."
    end

    with_options scope: [:included, :attributes] do
      response_field :description, "The question itself."
      response_field :options, "The set of possible answers to the question."
      response_field "created-at", "The date and time the answer was created."
      response_field "updated-at", "The last date and time the answer was updated."
    end

    get "quizzes/:id" do
      example "Retrieving a quiz" do
        expected_response = {
          "data" => {
            "id" => @quiz.id.to_s,
            "type" => "quiz",
            "attributes" => {
              "name" => "Friends trivia",
              "category" => "TV show",
              "created-at" => "2018-01-27T12:00:00.000Z",
              "updated-at" => "2018-01-27T12:00:00.000Z"
            },
            "links" => {
              "self" => {"href" => "/quizzes/#{@quiz.id}"}
            },
            "relationships" => {
              "questions" => {
                "data" => [
                  {"id" => @question_1.id.to_s, "type" => "question"},
                  {"id" => @question_2.id.to_s, "type" => "question"},
                  {"id" => @question_3.id.to_s, "type" => "question"},
                  {"id" => @question_4.id.to_s, "type" => "question"},
                  {"id" => @question_5.id.to_s, "type" => "question"}
                ]
              }
            }
          },
          "included" => [
            {
              "id" => @question_1.id.to_s,
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
                    "id" => @quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{@quiz.id}/questions/#{@question_1.id}"}
              }
            },
            {
              "id" => @question_2.id.to_s,
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
                    "id" => @quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{@quiz.id}/questions/#{@question_2.id}"}
              }
            },
            {
              "id" => @question_3.id.to_s,
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
                    "id" => @quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{@quiz.id}/questions/#{@question_3.id}"}
              }
            },
            {
              "id" => @question_4.id.to_s,
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
                    "id" => @quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{@quiz.id}/questions/#{@question_4.id}"}
              }
            },
            {
              "id" => @question_5.id.to_s,
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
                    "id" => @quiz.id.to_s,
                    "type" => "quiz"
                  }
                }
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{@quiz.id}/questions/#{@question_5.id}"}
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
