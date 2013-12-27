require 'haml/version'

# The module that contains everything Haml-related:
#
# * {Haml::Parser} is Haml's parser.
# * {Haml::Compiler} is Haml's compiler.
# * {Haml::Engine} is the class used to render Haml within Ruby code.
# * {Haml::Options} is where Haml's runtime options are defined.
# * {Haml::Error} is raised when Haml encounters an error.
#
# Also see the {file:REFERENCE.md full Haml reference}.
module Haml

  def self.init_rails(*args)
    # Maintain this as a no-op for any libraries that may be depending on the
    # previous definition here.
  end

end

# check for a compatible Rails version when Haml is loaded
if defined?(Rails) && (actionpack_spec = Gem.loaded_specs['actionpack'])
  if actionpack_spec.version.to_s < '3.2'
    raise Exception.new("\n\n** Haml now requires Rails 3.2 and later. Use Haml version 4.0.4\n\n")
  end
end

require 'haml/util'
require 'haml/engine'
require 'haml/railtie' if defined?(Rails::Railtie)
