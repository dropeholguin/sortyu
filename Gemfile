source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'foundation-rails', '~> 6.3'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.1'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-instagram'
gem 'paperclip'
gem "aws-ses", "~> 0.6.0", require: 'aws/ses'
gem 'aws-sdk', '~> 2.3'
gem "bower-rails", "~> 0.11.0"
gem 'wicked'
gem 'social-share-button'
gem 'stripe'
gem 'aasm'
gem 'koala'
gem 'instagram_api'
gem 'will_paginate', '~> 3.1', '>= 3.1.5'
gem 'acts_as_votable'
gem 'picasa'
gem 'activeadmin', github: 'activeadmin'
gem "recaptcha", require: "recaptcha/rails"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

