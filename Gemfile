source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specify your gem's dependencies in haml.gemspec
gemspec

gem 'benchmark-ips', '2.3.0'
gem 'maxitest'
gem 'base64'
gem 'bigdecimal'
gem 'mutex_m'

if /java/.match?(RUBY_PLATFORM) # JRuby
  gem 'pandoc-ruby'
  gem 'rdoc', '< 8' # rdoc 8 depends on rbs, whose native extension doesn't build on JRuby
else
  gem 'redcarpet'

  if RUBY_PLATFORM !~ /mswin|mingw/
    gem 'stackprof'
  end
end
