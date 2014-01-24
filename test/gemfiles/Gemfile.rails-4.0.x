source "https://rubygems.org"

if ENV['TRAVIS']
  platform :mri_21 do
    gem 'coveralls', require: false
  end
end

gem 'rails', '~> 4.0.0'
gemspec :path => '../..'

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
  gem 'json'
end
