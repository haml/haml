source "http://rubygems.org"

gem 'rails', '>= 3.0.0', '<  3.1.0'
gem 'rake', '< 11'
gem 'mime-types', '< 2'
if RUBY_VERSION < '1.9.2'
  gem 'nokogiri', '~> 1.5.0'
elsif RUBY_VERSION < '2.1'
  gem 'nokogiri', '~> 1.6.0'
else
  gem 'nokogiri', '>= 1.7'
end

gemspec :path => "../.."
