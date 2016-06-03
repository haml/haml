require 'mkmf'

houdini_dir = File.expand_path('./houdini', __dir__)
$INCFLAGS << " -I#{houdini_dir}"
$CFLAGS   << ' -Wall -Wextra'

$srcs = %w[hamlit.c]
Dir[File.join(houdini_dir, '*.c')].each do |path|
  src = File.basename(path)
  if /mswin|mingw/ =~ RUBY_PLATFORM
    FileUtils.cp(path, src)
  else
    FileUtils.ln_s(path, src, force: true)
  end
  $srcs << src
end

create_makefile('hamlit/hamlit')
