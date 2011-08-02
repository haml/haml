require 'rubygems'

# Note that Haml's gem-compilation process requires access to the filesystem.
# This means that it cannot be automatically run by e.g. GitHub's gem system.
# However, a build server automatically packages the master branch
# every time it's pushed to; this is made available as a prerelease gem.
HAML_GEMSPEC = Gem::Specification.new do |spec|
  spec.rubyforge_project = 'haml'
  spec.name = 'haml'
  spec.summary = "An elegant, structured XHTML/XML templating engine."
  spec.version = File.read(File.dirname(__FILE__) + '/VERSION').strip
  spec.authors = ['Nathan Weizenbaum', 'Hampton Catlin']
  spec.email = 'haml@googlegroups.com'
  spec.description = <<-END
      Haml (HTML Abstraction Markup Language) is a layer on top of XHTML or XML
      that's designed to express the structure of XHTML or XML documents
      in a non-repetitive, elegant, easy way,
      using indentation rather than closing tags
      and allowing Ruby to be embedded with ease.
      It was originally envisioned as a plugin for Ruby on Rails,
      but it can function as a stand-alone templating engine.
    END

  spec.add_development_dependency 'yard', '>= 0.5.3'
  spec.add_development_dependency 'maruku', '>= 0.5.9'
  spec.add_development_dependency 'hpricot'
  spec.add_development_dependency 'ruby_parser'

  readmes = Dir['*'].reject{ |x| x =~ /(^|[^.a-z])[a-z]+/ || x == "TODO" }
  spec.executables = ['haml', 'html2haml']
  spec.files = Dir['rails/init.rb', 'lib/**/*', 'bin/*', 'test/**/*',
    'extra/**/*', 'vendor/sass/**/*', 'Rakefile', 'init.rb', '.yardopts'] + readmes
  spec.homepage = 'http://haml-lang.com/'
  spec.has_rdoc = false
  spec.test_files = Dir['test/**/*_test.rb']
end
