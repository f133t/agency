source 'https://rubygems.org'

gem 'rails', '~> 5.1.4'
gem 'sidekiq'
gem 'redis-namespace'
gem 'mysql2'
gem 'httparty', '0.15.6', path: 'vendor/gems/httparty'
gem 'extractor-session', path: 'vendor/gems/extractor-session'
gem 'mail'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
