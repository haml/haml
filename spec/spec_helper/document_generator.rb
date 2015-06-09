require 'singleton'

class DocumentGenerator
  class << self
    def incompatibilities
      @incompatibilities ||= []
    end

    def generate_docs!
      prepare_dirs!
      generate_toc!

      incompatibilities.group_by(&:doc_path).each do |path, tests|
        doc = tests.sort_by(&:lineno).map(&:document).join("\n")
        full_path = File.join(doc_dir, path)
        File.write(full_path, doc)
      end
    end

    def generate_docs?
      ENV['AUTODOC']
    end

    def register_test!(test)
      incompatibilities << test unless @skipdoc
    end

    def skipdoc(&block)
      @skipdoc = true
      block.call
    ensure
      @skipdoc = false
    end

    private

    def generate_toc!
      table_of_contents = <<-TOC.unindent
        # Hamlit incompatibilities

        This is a document generated from RSpec test cases.  
        Showing incompatibilities against [Haml](https://github.com/haml/haml) and [Faml](https://github.com/eagletmt/faml).
      TOC

      incompatibilities.group_by(&:dir).each do |dir, tests|
        # TODO: Split incompatibility documents into haml and faml
        # There are too many noisy documents now.
        table_of_contents << "\n## #{dir}\n"

        tests.group_by(&:doc_path).each do |path, tests|
          table_of_contents << "\n- [#{tests.first.spec_path}](#{path})"
        end
        table_of_contents << "\n"
      end

      path = File.join(doc_dir, 'README.md')
      File.write(path, table_of_contents)
    end

    def prepare_dirs!
      system("rm -rf #{doc_dir}")
      incompatibilities.map(&:dir).uniq.each do |dir|
        system("mkdir -p #{doc_dir}/#{dir}")
      end
    end

    def doc_dir
      @doc_dir ||= File.expand_path('./doc')
    end
  end
end
