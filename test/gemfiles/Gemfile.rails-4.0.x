source "https://rubygems.org"

if ENV['TRAVIS']
  platform :mri_21 do
    gem 'coveralls', require: false
  end
end

gem 'rails', '~> 4.0.0'
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gemspec :path => '../..'
