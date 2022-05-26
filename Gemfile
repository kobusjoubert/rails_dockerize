source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Nokogiri.
#
# For a faster more reliable installation. "Native gems" contain pre-compiled libraries for a specific machine architecture. On supported platforms, this
# removes the need for compiling the C extension and the packaged libraries, or for system dependencies to exist. This results in much faster installation and
# more reliable installation, which as you probably know are the biggest headaches for Nokogiri users.
# [https://nokogiri.org/tutorials/installing_nokogiri.html#installing-using-the-packaged-libraries]
#
# As of v1.11.0, Nokogiri ships pre-compiled, "native" gems for the following platforms:
#
#   - Linux: x86-linux and x86_64-linux (req: glibc >= 2.17), including musl platforms like Alpine
#   - Darwin/MacOS: x86_64-darwin and arm64-darwin
#   - Windows: x86-mingw32 and x64-mingw32
#   - Java: any platform running JRuby 9.2 or higher
#
# If you're on a supported platform, either gem install or bundle install should install a native gem without any additional action on your part.
#
# If you're using Bundler v2.2+, check that your lockfile knows about your platform(s). For example, if you develop on macOS and deploy to Linux you will need
# to run these commands in your development environment:
#
#   bundle lock --add-platform x86_64-linux
#
# Add support for the required platforms locally and for production.
#
#   bundle lock --add-platform x86_64-linux-musl
#   bundle lock --add-platform x86_64-darwin-20
#   bundle lock --add-platform aarch64-linux-musl
#   bundle lock --add-platform arm64-darwin-21
#   bundle package --all-platforms
gem "nokogiri"

# Use Sidekiq for background processing.
gem "sidekiq"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv-rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
