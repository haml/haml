require 'unindent'

# This is used to generate a document automatically.
class TestCase < Struct.new(:file, :dir, :lineno, :src_haml, :haml_html, :faml_html, :hamlit_html)
  def document
    base_path = '/spec/hamlit'
    path = File.join(base_path, dir, file)
    doc = <<-DOC
# [#{escape_markdown("#{file}:#{lineno}")}](#{path}#L#{lineno})
## Input
```haml
#{src_haml}
```

## Output
    DOC

    html_by_name = {
      'Haml' => haml_html,
      'Faml' => faml_html,
      'Hamlit' => hamlit_html,
    }
    html_by_name.group_by(&:last).each do |html, pairs|
      doc << "### #{pairs.map(&:first).join(', ')}\n"
      doc << "```html\n"
      doc << "#{html}\n"
      doc << "```\n\n"
    end

    doc
  end

  def doc_path
    File.join(dir, file.gsub(/_spec\.rb$/, '.md'))
  end

  def spec_path
    path = File.join(dir, file)
    escape_markdown(path)
  end

  private

  def escape_markdown(text)
    text.gsub(/_/, '\\_')
  end
end
