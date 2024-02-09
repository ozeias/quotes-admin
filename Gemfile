source 'https://rubygems.org'

ruby '3.3.0'
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', github: 'rails/rails', branch: 'main'

# Drivers
gem 'pg'
gem 'redis'

# Deployment
gem 'puma'

# Jobs
gem 'resque', '~> 2.6.0'
gem 'resque-pool', '~> 0.7.1'
gem 'mission_control-jobs'

# Assets
gem 'importmap-rails', github: 'rails/importmap-rails'
gem 'propshaft', github: 'rails/propshaft'

# Hotwire
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', github: 'hotwired/turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Media handling
# gem 'image_processing', '>= 1.2'

# Telemetry
# gem 'rails_semantic_logger', '~> 5.0'
# gem 'sentry-ruby'
# gem 'sentry-rails'

# Other
gem 'bcrypt'
gem 'geared_pagination'
gem 'jbuilder'
gem 'kredis'
gem 'net-http-persistent'
gem 'platform_agent'
gem 'rails_autolink'
gem 'rqrcode'
gem 'uuid7'
gem 'web-push'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug'
  gem 'faker', require: false
  gem 'pry-rails'
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'mocha'
  gem 'selenium-webdriver'
  gem 'webmock', require: false
end
