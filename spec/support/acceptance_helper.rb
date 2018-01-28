require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:json, :combined_text, :html]
  config.curl_host = 'http://localhost:3000/'
  config.api_name = "Quiz API"
  config.api_explanation = "This is a simple API to create custom quizzes and to grade them"
end
