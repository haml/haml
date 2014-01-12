source "https://rubygems.org"

gem 'rails', '4.1.0.beta1'
gemspec :path => '../..'

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
end
