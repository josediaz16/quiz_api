require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe QuizzesController, type: :request do
  before { Timecop.freeze(2018, 1, 27, 12) }
  after { Timecop.return }

  resource "Quizzes" do

    let(:quiz_1) { Quiz.create(name: "My sports quiz", category: "sports") }
    let(:quiz_2) { Quiz.create(name: "My cooking quiz", category: "cook") }

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
