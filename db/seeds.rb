# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
quiz = Quiz.create(name: "Friends trivia", category: "TV show")
Question.create(quiz: quiz, description: "Name of Monica's brother", options: ['Chandler', 'Ross', 'Joey', 'Mike'], answer: "Ross")
Question.create(quiz: quiz, description: "Who says vafanapoli?", options: ['Rachel', 'Monica', 'Joey', 'Mike'], answer: "Joey")
Question.create(quiz: quiz, description: "How many sisters does Joey have?", options: ['7', '3', '4', '0'], answer: "7")
Question.create(quiz: quiz, description: "Almost beat pacman's record", options: ['Jack', 'Ben', 'Gunther', 'Phoebe'], answer: "Phoebe")
Question.create(quiz: quiz, description: "Who says 'I'm not great at the advice. Can I interest you in a sarcastic comment?'", options: ['Chandler', 'Rachel', 'Joey', 'Frankie Jr'], answer: "Chandler")
