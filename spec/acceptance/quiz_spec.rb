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
        expected_response = [
          { "id" => quiz_1.id, "name" => "My sports quiz", "category" => "sports", "created_at" => "2018-01-27T12:00:00.000Z", "updated_at" => "2018-01-27T12:00:00.000Z" },
          { "id" => quiz_2.id, "name" => "My cooking quiz", "category" => "cook", "created_at" => "2018-01-27T12:00:00.000Z", "updated_at" => "2018-01-27T12:00:00.000Z" }
        ]

        do_request
        response = JSON.parse(response_body)
        expect(response).to match_array expected_response
      end
    end
  end

  context "No quiz exists" do
    example "Should return ok" do
      get '/quizzes'
      expect(response.status).to eq(200)
    end
  end
end
