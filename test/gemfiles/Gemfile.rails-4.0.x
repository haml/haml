source "http://rubygems.org"

gem 'rails', '~> 4.0.0'
gem 'mime-types', '< 3'
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gemspec :path => '../..'
