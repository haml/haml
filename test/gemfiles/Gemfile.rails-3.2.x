source "https://rubygems.org"

gem 'rails', '~> 3.2.0'
gemspec :path => "../.."

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
end
