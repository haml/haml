require 'mkmf'

houdini_dir = File.expand_path('./houdini', __dir__)
$INCFLAGS << " -I#{houdini_dir}"
$CFLAGS   << ' -Wall -Wextra'

$srcs = %w[hamlit.c]
Dir[File.join(houdini_dir, '*.c')].each do |path|
  src = File.basename(path)
  begin
    FileUtils.ln_s(path, src, force: true)
  rescue NotImplementedError
    # For the error on windows:
    # symlink() function is unimplemented on this machine (NotImplementedError)
    FileUtils.cp(path, src)
  end
  $srcs << src
end

create_makefile('hamlit/hamlit')
