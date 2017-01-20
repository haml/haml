source "http://rubygems.org"

gem 'rails', '>= 3.0.0', '<  3.1.0'
gem 'rake', '< 11'
gem 'mime-types', '< 2'
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gemspec :path => "../.."

