require 'hamlit/cli'

describe Hamlit::CLI do
  describe '#temple' do
    def redirect_output
      out, $stdout = $stdout, StringIO.new
      yield
    ensure
      $stdout = out
    end

    it 'does not crash when compiling a tag' do
      redirect_output do
        f = Tempfile.open('hamlit')
        f.write('%input{ hash }')
        f.close
        Hamlit::CLI.new.temple(f.path)
      end
    end
  end
end
