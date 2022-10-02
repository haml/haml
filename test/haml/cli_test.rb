require 'haml/cli'

describe Haml::CLI do
  describe '#temple' do
    def redirect_output
      out, $stdout = $stdout, StringIO.new
      yield
    ensure
      $stdout = out
    end

    it 'does not crash when compiling a tag' do
      redirect_output do
        f = Tempfile.open('haml')
        f.write('%input{ hash }')
        f.close
        Haml::CLI.new.temple(f.path)
      end
    end
  end
end
