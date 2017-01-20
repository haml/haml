source "https://rubygems.org"

gem 'rails', '~> 4.2.0'

if RUBY_VERSION >= '2.0.0'
  gem 'mime-types'
else
  gem 'mime-types', '2.99'
end

gemspec :path => '../..'
