source "https://rubygems.org"
gemspec

group :docs do
  gem "yard", "~> 0.8.0"
  gem "maruku"
end

group :test do
  gem "coveralls", require: false
end

platform :mri do
  gem "ruby-prof"
end

platform :mri_19 do
  gem "simplecov"
end
