# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

p 'Seeding...'
User.create!([{name: 'Ivan', login: 'ivan1957', password: '1111'}, {name: 'Andrew', login: 'andryusha', password: '2222'}])
User.first.authored_quizzes.create!(title: 'Test')
Quiz.first.questions.create!([{text: 'Kak kakat?', question_type: 0}, {text: 'Kto takoe Cherephoy?', question_type: 2}])
Question.first.answers.create!([{text: 'Kak', right: true}, {text: 'A kak?', right: false}, {text: 'Kak-to tak', right: false}, {text: 'Nikak', right: false}])
Question.last.answers.create!([{text: 'Komol', right: false}, {text: 'komol', right: false}, {text: 'kamol', right: false}, {text: 'Kamol', right: false}, {text: 'Cumall', right: true}])
User.last.authored_quizzes.create!(:title => 'Andrew\'s quiz')
User.first.quizzes << Quiz.first
User.first.quizzes << Quiz.last
User.create!(name: 'Test', login: 'test', password: 'test')
p 'Complete'
