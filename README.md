# Hamlit

Hamlit is a high performance [Haml](https://github.com/haml/haml) implementation.

## Introduction

### What is Hamlit?
Hamlit is another implementation of [Haml](https://github.com/haml/haml) and designed to make Haml language faster than
[Slim](https://github.com/slim-template/slim). With some [limitations](REFERENCE.md#limitations) by
design for performance, Hamlit is **7.16x times faster** than original haml gem in
[this benchmark](benchmark/slim/run-benchmarks.rb), which is an HTML-escaped version of [slim-template/slim's one](https://github.com/slim-template/slim/blob/v3.0.6/benchmarks/run-benchmarks.rb) for fairness.

![Hamlit Benchmark](http://i.gyazo.com/4fe00ff2ac2fa959dfcf86a5e27dc914.png)

### Why is Hamlit faster?

#### Less string concatenation by design
As written in [limitations](REFERENCE.md#limitations), Hamlit drops some not-so-important features which require
works on runtime. With the optimized language design, we can reduce the string concatenation
to build attributes.

#### Temple optimizers
Hamlit is built with [Temple](https://github.com/judofyr/temple), which is a framework to build
template engines and also used in Slim. By using the framework and its optimizers, Hamlit can
reduce string allocation and concatenation easily.

#### Static analyzer
Hamlit analyzes Ruby expressions with Ripper and render it on compilation if the expression
is static.

#### C extension to build attributes
While Hamlit has static analyzer and static attributes are rendered on compilation,
dynamic attributes should be rendered on runtime. So Hamlit optimizes rendering on runtime
with C extension.

## Usage

See [REFERENCE.md](REFERENCE.md) for detail features of Hamlit.

### Rails

Add this line to your application's Gemfile or just replace `gem "haml"` with `gem "hamlit"`.
It enables rendering by Hamlit for \*.haml automatically.

```rb
gem 'hamlit'
```

If you want to use view generator, consider using [hamlit-rails](https://github.com/mfung/hamlit-rails).

### Sinatra

Replace `gem "haml"` with `gem "hamlit"` in Gemfile, and require "hamlit".
See [sample/sinatra](sample/sinatra) for working sample.

While Haml disables `escape_html` option by default, Hamlit enables it for security.
If you want to disable it, please write:

```rb
set :haml, { escape_html: false }
```


## Command line interface

'hamlit' command is available if you install thor gem with `gem install thor`.

```bash
$ gem install hamlit thor
$ hamlit --help
Commands:
  hamlit compile HAML    # Show compile result
  hamlit help [COMMAND]  # Describe available commands or one specific command
  hamlit parse HAML      # Show parse result
  hamlit render HAML     # Render haml template
  hamlit temple HAML     # Show temple intermediate expression

$ cat in.haml
.foo#bar

# Show compiled code
$ hamlit compile in.haml
_buf = "<div class='foo' id='bar'></div>\n"

# Render html
$ hamlit render in.haml
<div class='foo' id='bar'></div>
```

## Contributing

### Development

Contributions are welcomed. It'd be good to see
[Temple's EXPRESSIONS.md](https://github.com/judofyr/temple/blob/v0.7.6/EXPRESSIONS.md)
to learn Temple which is a template engine framework used in Hamlit.

```bash
$ git clone https://github.com/k0kubun/hamlit
$ cd hamlit
$ bundle install

# Run all tests
$ bundle exec rake test

# Run one test
$ bundle exec ruby -Ilib:test -rtest_helper test/hamlit/line_number_test.rb -l 12

# Show compiling/rendering result of some template
$ bundle exec exe/hamlit compile in.haml
$ bundle exec exe/hamlit render in.haml

# Use rails app to debug Hamlit
$ cd sample/rails
$ bundle install
$ bundle exec rails s
```

### Reporting an issue

Please report an issue with following information:

- Full error backtrace
- Haml template
- Ruby version
- Hamlit version
- Rails/Sinatra version

## License

MIT License

Copyright (c) 2015 Takashi Kokubun

### Parser and Haml tests

lib/hamlit/parser/\*.rb and test/haml/\* are:

Copyright (c) 2006-2009 Hampton Catlin and Natalie Weizenbaum

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
