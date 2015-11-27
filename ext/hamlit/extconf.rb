require 'mkmf'

houdini_dir = File.expand_path('./houdini', __dir__)
$INCFLAGS << " -I#{houdini_dir}"
$CFLAGS << ' -Wall -Wextra'

$srcs = %w[hamlit.c]
Dir[File.join(houdini_dir, '*.c')].each do |path|
  src = File.basename(path)
  FileUtils.ln_s(File.join(houdini_dir, src), src, force: true)
  $srcs << src
end

create_makefile('hamlit/hamlit')
