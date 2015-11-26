require 'mkmf'

$CFLAGS << ' -Wall -Wextra'
create_makefile('hamlit/hamlit')
