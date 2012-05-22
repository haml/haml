require 'haml/version'

# The module that contains everything Haml-related:
#
# * {Haml::Engine} is the class used to render Haml within Ruby code.
# * {Haml::Helpers} contains Ruby helpers available within Haml templates.
# * {Haml::Template} interfaces with web frameworks (Rails in particular).
# * {Haml::Error} is raised when Haml encounters an error.
# * {Haml::HTML} handles conversion of HTML to Haml.
#
# Also see the {file:REFERENCE.md full Haml reference}.
module Haml
end

require 'haml/util'
require 'haml/engine'
require 'haml/railtie' if defined?(Rails)
