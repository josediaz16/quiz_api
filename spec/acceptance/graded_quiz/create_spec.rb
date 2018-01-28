require 'support/acceptance_helper'

RSpec.describe QuizzesController, type: :request do
  resource "Graded Quizzes" do
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

    parameter :quiz_id, "The identifier of the quiz to grade", required: true

    with_options scope: :quiz do
      parameter :author, "The name of who submits the quiz"
      parameter :questions_attributes, "The set of questions and answers needed to grade the quiz, for detailed documentation of each field of question, see below"
    end

    with_options scope: [:quiz, :questions_attributes] do
      parameter :id, "The id of the question to answer", required: true, method: :none
      parameter :answer, "The answer to submit"
    end

    let(:quiz_id) { @quiz.id }
    let(:author) { "Janice" }

    let(:questions_attributes) do
      [
        {"id" => @question_1.id, "answer" => 'Ross'},
        {"id" => @question_2.id, "answer" => 'Mike'},
        {"id" => @question_3.id, "answer" => '7'},
        {"id" => @question_4.id, "answer" => 'Phoebe'},
        {"id" => @question_5.id, "answer" => 'Chandler'},
      ]
    end

    post "/quizzes/:quiz_id/grade" do
      context "A successful request" do
        let(:raw_post) { params.to_json }

        example "Grading a quiz" do
          expect(params).to eq({
            "quiz"=> {
              "author"=>"Janice",
              "questions_attributes"=> [
                {"id" => @question_1.id, "answer" => "Ross"},
                {"id" => @question_2.id, "answer" => "Mike"},
                {"id" => @question_3.id, "answer" => '7'},
                {"id" => @question_4.id, "answer" => 'Phoebe'},
                {"id" => @question_5.id, "answer" => 'Chandler'},
              ]
            }
          })

          do_request
          expect(status).to eq(201)

          graded_quiz = GradedQuiz.last

          response = JSON.parse(response_body)
          expect(response). to eq({"id" => graded_quiz.id, "score" => "8.0"})
        end
      end
    end
  end
end
