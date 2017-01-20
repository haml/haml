source "https://rubygems.org"

gem 'rails', '~> 4.1.0'

if RUBY_VERSION >= '2.0.0'
  gem 'mime-types'
else
  gem 'mime-types', '2.99'
end
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'

gemspec :path => '../..'
