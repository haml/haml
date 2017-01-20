source "http://rubygems.org"

gem 'rails', '>= 3.1.0', '< 3.2.0'
gem 'rake', '< 11'
gem 'i18n', '< 0.7.0'
gem 'mime-types', '< 2'
gem 'rack-cache',  '< 1.3'
if RUBY_VERSION < '1.9.2'
  gem 'nokogiri', '~> 1.5.0'
elsif RUBY_VERSION < '2.1'
  gem 'nokogiri', '~> 1.6.0'
else
  gem 'nokogiri', '>= 1.7'
end

gemspec :path => "../.."
