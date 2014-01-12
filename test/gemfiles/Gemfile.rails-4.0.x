source "https://rubygems.org"

gem 'coveralls', require: false
gem 'rails', '~> 4.0.0'
gemspec :path => '../..'

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
  gem 'json'
  gem 'rubinius-developer_tools'
end