source "https://rubygems.org"
gemspec

group :docs do
  gem "yard", "~> 0.8.0"
  gem "rdoc"
end

platform :mri do
  gem "ruby-prof"
end

platform :mri_21 do
  gem "simplecov"
end

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
end
