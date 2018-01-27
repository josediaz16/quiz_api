source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
# gem 'jbuilder', '~> 2.5'
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development
# gem 'rack-cors'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec_api_documentation'
end

group :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'factory_bot'
  gem 'database_cleaner'
  gem 'timecop'
end

group :development do
  gem 'listen', '~> 3.0.5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
