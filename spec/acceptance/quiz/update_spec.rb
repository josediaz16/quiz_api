require 'support/acceptance_helper'

RSpec.describe QuizzesController, type: :request do
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

    header 'Content-Type', "application/json"

    parameter :id, "The identifier of the quiz", required: true

    with_options scope: :quiz do
      parameter :name, "Quiz Name"
      parameter :category, "Quiz Category"
      parameter :questions_attributes, "A set of only the questions to update, for detailed documentation of each field of question, see below"
    end

    with_options scope: [:quiz, :questions_attributes] do
      parameter :id, "The id of the question to update", required: true, method: :none
      parameter :description, "The question itself"
      parameter :options, "An array of possible answers"
      parameter :answer, "The correct answer from the options set"
    end


    let(:id) { @quiz.id }
    let(:name) { "A New Friends Trivia" }
    let(:questions_attributes) do
      [
        {
          "id" => @question_1.id,
          "description" => "Who got stung by a jellyfish?",
          "options" => ['Chandler', 'Monica', 'Joey', 'Mike'],
          "answer" => "Monica"
        },
        {
          "id" => @question_5.id,
          "description" => "Name of Ross's monkey",
          "options" => ['Regina Falangie', 'Ken', 'Marcel', 'Ben'],
          "answer" => "Marcel"
        }
      ]
    end

    put "/quizzes/:id" do
      context "A successful request" do
        let(:raw_post) { params.to_json }

        example "Updating a quiz" do
          expect(params).to eq({
            "quiz"=> {
              "name"=>"A New Friends Trivia",
              "questions_attributes"=> [
                {
                  "id" => @question_1.id,
                  "description" => "Who got stung by a jellyfish?",
                  "options" => ['Chandler', 'Monica', 'Joey', 'Mike'],
                  "answer" => "Monica"
                },
                {
                  "id" => @question_5.id,
                  "description" => "Name of Ross's monkey",
                  "options" => ['Regina Falangie', 'Ken', 'Marcel', 'Ben'],
                  "answer" => "Marcel"
                }
              ]
            }
          })

          do_request

          expect(status).to eq(200)
          response = JSON.parse(response_body)
          expect(response). to eq({"id" => @quiz.id})

          @quiz.reload
          @question_1.reload
          @question_5.reload

          expect(@quiz.name).to eq("A New Friends Trivia")
          expect(@quiz.questions.count).to eq(5)

          expect(@question_1.description).to eq("Who got stung by a jellyfish?")
          expect(@question_1.options).to match_array(['Chandler', 'Monica', 'Joey', 'Mike'])
          expect(@question_1.answer).to eq("Monica")

          expect(@question_5.description).to eq("Name of Ross's monkey")
          expect(@question_5.options).to match_array(['Regina Falangie', 'Ken', 'Marcel', 'Ben'])
          expect(@question_5.answer).to eq("Marcel")
        end
      end

      context "Sending a blank name" do
        let!(:name) { "" }
        let(:raw_post) { params.to_json }

        example "Should respond 400", document: false do
          do_request

          expect(status).to eq(400)

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

        example "Should respond 200", document: false do
          do_request

          expect(status).to eq(200)

          response = JSON.parse(response_body)
          expect(response). to eq({"id" => @quiz.id})

          @quiz.reload
          expect(@quiz.name).to eq("A New Friends Trivia")
        end
      end
    end
  end
end
