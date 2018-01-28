require 'support/acceptance_helper'

RSpec.describe QuizzesController, type: :request do
  before { Timecop.freeze(2018, 1, 27, 12) }
  after { Timecop.return }

  resource "Quizzes" do

    let(:quiz_1) { create(:quiz, name: "My sports quiz", category: "sports") }
    let(:quiz_2) { create(:quiz, name: "My cooking quiz", category: "cook") }

    response_field :data, "The list of quizzes available."

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

    header "Accept", "application/json"
    get "/quizzes" do
      example "Listing quizzes" do
        expected_response = {
          "data" => [
            {
              "id" => quiz_1.id.to_s,
              "type" => "quiz",
              "attributes" => {
                "name" => "My sports quiz",
                "category" => "sports",
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz_1.id}"}
              }
            },
            {
              "id" => quiz_2.id.to_s,
              "type" => "quiz",
              "attributes" => {
                "name" => "My cooking quiz",
                "category" => "cook",
                "created-at" => "2018-01-27T12:00:00.000Z",
                "updated-at" => "2018-01-27T12:00:00.000Z"
              },
              "links" => {
                "self" => {"href" => "/quizzes/#{quiz_2.id}"}
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

  context "No quiz exists" do
    example "Should return ok" do
      get '/quizzes'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({"data" => []})
    end
  end
end
