# QUIZ API

This is a very small example of an API built using the following tools and considerations:
  - Docker
  - Ruby on Rails 5
  - Test driven development using RSpec
  - RESTFUL concepts
  - Basic HATEOAS Navigation
  - Basic documentation using RSpec api documentation

* Dependencies

  This project was built using the following versions:
    - Docker version 17.03.1-ce, build c6d412e
    - docker-compose version 1.11.2, build dfed245

* Configuration

  As initial step run the following command to setup the database:

  `sudo docker-compose run quiz_api rails db:create db:migrate`

  Run `sudo docker-compose run quiz_api rails db:create db:seed` to initialize the database with a couple of records.

* Tests

  To run the tests run `sudo docker-compose run quiz_api bundle exec rspec spec/`

* Documentation

  To run the tests and generate the docs run `sudo docker-compose run quiz_api bundle exec rake docs:generate`

  After running that you can check the documentation starting the server and visiting '/api/doc/index.html',
  or opening the file on public/api/doc/index.html with your default browser.

