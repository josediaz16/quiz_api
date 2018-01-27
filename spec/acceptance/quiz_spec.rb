require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Quizzes" do
  describe "Listing quizzes" do

    let(:quiz_1) { Quiz.create(name: "My sports quiz", category: "sports") }
    let(:quiz_1) { Quiz.create(name: "My cooking quiz", category: "cook") }

    get "/quizzes" do
      context "No quiz exists" do
        example "Should return ok" do
          do_request
          expect(status).to be_ok
        end
      end
      context "Some quizzes exist" do
        example "Should return a list of quizzes" do
          do_request
          response = JSON.parse(last_response.body)
          expect(reponse).to match_array [
            { id: quiz_1.id, name: "My sports quiz", category: "sports" },
            { id: quiz_1.id, name: "My cooking quiz", category: "cooking" }
          ]
        end
      end
    end

  end
end
