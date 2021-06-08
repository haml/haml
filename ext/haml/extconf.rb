require 'mkmf'

$CFLAGS << ' -Wall -Wextra'

$srcs = %w[
  haml.c
  hescape.c
]

create_makefile('haml/haml')
