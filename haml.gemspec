($LOAD_PATH << File.expand_path("../lib", __FILE__)).uniq!
require "haml/version"

Gem::Specification.new do |spec|
  spec.name        = 'haml'
  spec.summary     = "An elegant, structured (X)HTML/XML templating engine."
  spec.version     = Haml::VERSION
  spec.authors     = ['Nathan Weizenbaum', 'Hampton Catlin', 'Norman Clarke']
  spec.email       = ['haml@googlegroups.com', 'norman@njclarke.com']

  readmes          = Dir['*'].reject{ |x| x =~ /(^|[^.a-z])[a-z]+/ || x == "TODO" }
  spec.executables = ['haml']
  spec.files       = Dir['rails/init.rb', 'lib/**/*', 'bin/*', 'test/**/*',
                         'extra/**/*', 'Rakefile', 'init.rb', '.yardopts'] + readmes
  spec.homepage    = 'http://haml.info/'
  spec.has_rdoc    = false
  spec.test_files  = Dir["test/**/*_test.rb"]
  spec.license     = "MIT"

  spec.add_dependency "tilt"

  spec.add_development_dependency 'rails', '>= 3.0.0'
  spec.add_development_dependency 'rbench'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'nokogiri'

  spec.description = <<-END
Haml (HTML Abstraction Markup Language) is a layer on top of HTML or XML that's
designed to express the structure of documents in a non-repetitive, elegant, and
easy way by using indentation rather than closing tags and allowing Ruby to be
embedded with ease. It was originally envisioned as a plugin for Ruby on Rails,
but it can function as a stand-alone templating engine.
END

  spec.post_install_message = <<-END

HEADS UP! Haml 3.2 has many improvements, but also has changes that may break
your application:

* Support for Ruby 1.8.6 dropped
* Support for Rails 2 dropped
* Sass filter now always outputs <style> tags
* Data attributes are now hyphenated, not underscored
* html2haml utility moved to the html2haml gem
* Textile and Maruku filters moved to the haml-contrib gem

For more info see:

http://rubydoc.info/github/haml/haml/file/CHANGELOG.md

END


end
