require 'support/acceptance_helper'

RSpec.describe GradedQuizzesController, type: :request do
  before { Timecop.freeze(2018, 1, 27, 12) }
  after { Timecop.return }

  resource "Graded Quizzes" do
    before do
      @quiz = Quiz.new(name: "Friends trivia", category: "TV show")
      @question_1 = @quiz.questions.build(description: "Name of Monica's brother", options: ['Chandler', 'Ross', 'Joey', 'Mike'], answer: "Ross")
      @question_2 = @quiz.questions.build(description: "Who says vafanapoli?", options: ['Rachel', 'Monica', 'Joey', 'Mike'], answer: "Joey")
      @question_3 = @quiz.questions.build(description: "How many sisters does Joey have?", options: ['7', '3', '4', '0'], answer: "7")
      @question_4 = @quiz.questions.build(description: "Almost beat pacman's record", options: ['Jack', 'Ben', 'Gunther', 'Phoebe'], answer: "Phoebe")
      @question_5 = @quiz.questions.build(description: "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'", options: ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'], answer: "Chandler")
      @quiz.save

      grader = Quizzes::Grader.new(@quiz,
        [
          {id: @question_1.id, answer: "Ross"},
          {id: @question_2.id, answer: "Joey"},
          {id: @question_3.id, answer: "7"},
          {id: @question_4.id, answer: "Gunther"},
          {id: @question_5.id, answer: "Chandler"},
        ]
      )

      grader.perform
      @graded_quiz = GradedQuiz.last
      @wrong_answer = Answer.find_by(description: "Gunther")
    end

    let(:quiz_id) { @quiz.id }
    let(:id) { @graded_quiz.id }

    header "Accept", "application/json"

    with_options scope: :data do
      response_field :id, "The unique identifier of the graded quiz."
      response_field :attributes, "Detailed data about the graded quiz."
    end

    with_options scope: :attributes do
      response_field :author, "The name of the person who submitted the quiz."
      response_field :score, "The total score of the graded quiz."
      response_field "created-at", "The date and time the quiz was submitted."
      response_field "updated-at", "The last date and time the quiz was updated."
    end

    response_field :included, "Detailed data about each question that was uncorrectly answered."

    with_options scope: :included do
      response_field :id, "The unique identifier of the answer."
    end

    with_options scope: [:included, :attributes] do
      response_field :description, "The answer itself."
      response_field :question, "The question related to this answer."
      response_field "created-at", "The date and time the answer was was submitted."
    end

    get "quizzes/:quiz_id/graded_quizzes/:id" do
      example "Retrieving a graded quiz" do
        expected_response = {
          "data" => {
            "id" => @graded_quiz.id.to_s,
            "type" => "graded-quiz",
            "attributes" => {
              "author" => "anonymous",
              "score" => "8.0",
              "created-at" => "2018-01-27T12:00:00.000Z",
              "updated-at" => "2018-01-27T12:00:00.000Z"
            },
            "links" => {
              "self" => {"href" => "/quizzes/#{@quiz.id}/graded_quizzes/#{@graded_quiz.id}"}
            },
            "relationships" => {
              "answers" => {
                "data" => [
                  {"id" => @wrong_answer.id.to_s, "type" => "answer"},
                ]
              }
            }
          },
          "included" => [
            {
              "id" => @wrong_answer.id.to_s,
              "type" => "answer",
              "attributes" => {
                "question" => "Almost beat pacman's record",
                "description" => "Gunther",
                "created-at" => "2018-01-27T12:00:00.000Z",
              },
              "relationships" => {
                "graded-quiz" => {
                  "data" => {
                    "id" => @graded_quiz.id.to_s,
                    "type" => "graded-quiz"
                  }
                }
              }
            }
          ]
        }

        do_request
        response = JSON.parse(response_body)

        expect(status).to eq(200)
        expect(response).to eq expected_response
      end
    end
  end
end
