require 'singleton'

class DocumentGenerator
  class << self
    def incompatibilities
      @incompatibilities ||= []
    end

    def generate_docs!
      prepare_dirs!

      [nil, 'haml', 'faml'].each do |impl|
        generate_toc!(impl)
        generate_doc!(impl)
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

    def generate_doc!(impl)
      incompatibilities_for(impl).group_by(&:doc_path).each do |path, tests|
        doc = tests.sort_by(&:lineno).map { |t| t.document(impl) }.join("\n")
        full_path = File.join(*[doc_dir, impl, path].compact)
        File.write(full_path, doc)
      end
    end

    def generate_toc!(impl = nil)
      path = File.join(*[doc_dir, impl, 'README.md'].compact)
      File.write(path, table_of_contents_for(impl))
    end

    def table_of_contents_for(impl = nil)
      toc = "# Hamlit incompatibilities\nThis is a document generated from RSpec test cases.  "
      toc << "\n#{target_description(impl)}"

      incompatibilities_for(impl).group_by(&:dir).each do |dir, tests|
        toc << "\n\n## #{dir}\n"
        tests.map { |t| [t.spec_path, t.doc_path] }.uniq.each do |spec_path, doc_path|
          toc << "- [#{spec_path}](#{doc_path})\n"
        end
      end
      toc
    end

    def incompatibilities_for(impl)
      return incompatibilities unless impl
      incompatibilities.select { |t| t.send(:"#{impl}_html") != t.hamlit_html }
    end

    def target_description(impl)
      case impl
      when 'haml'
        'Showing incompatibilities against [Haml](https://github.com/haml/haml).'
      when 'faml'
        'Showing incompatibilities against [Faml](https://github.com/eagletmt/faml).'
      else
        'Showing incompatibilities against [Haml](https://github.com/haml/haml) and [Faml](https://github.com/eagletmt/faml).'
      end
    end

    def prepare_dirs!
      system("rm -rf #{doc_dir}")
      incompatibilities.map(&:dir).uniq.each do |dir|
        system("mkdir -p #{File.join(doc_dir, dir)}")
      end
      %w[haml faml].each do |impl|
        incompatibilities.map(&:dir).uniq.each do |dir|
          system("mkdir -p #{File.join(doc_dir, impl, dir)}")
        end
      end
    end

    def doc_dir
      @doc_dir ||= File.expand_path('./doc')
    end
  end
end
