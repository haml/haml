source "http://rubygems.org"

gem 'rails', '>= 3.1.0', '< 3.2.0'
gem 'rake', '< 11'
gem 'i18n', '< 0.7.0'
gem 'mime-types', '< 2'
gem 'rack-cache',  '< 1.3'
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gemspec :path => "../.."
