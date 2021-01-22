# Hamlit

[![Gem Version](https://badge.fury.io/rb/hamlit.svg)](http://badge.fury.io/rb/hamlit)
[![test](https://github.com/k0kubun/hamlit/workflows/test/badge.svg)](https://github.com/k0kubun/hamlit/actions?query=workflow%3Atest)

Hamlit is a high performance [Haml](https://github.com/haml/haml) implementation.

## Introduction

### What is Hamlit?
Hamlit is another implementation of [Haml](https://github.com/haml/haml).
With some [limitations](REFERENCE.md#limitations) by design for performance,
Hamlit is **1.94x times faster** than original haml gem in [this benchmark](benchmark/slim/run-benchmarks.rb),
which is an HTML-escaped version of [slim-template/slim's one](https://github.com/slim-template/slim/blob/4.1.0/benchmarks/run-benchmarks.rb) for fairness. ([Result on Travis](https://travis-ci.org/github/k0kubun/hamlit/jobs/732178446))

<img src="https://raw.githubusercontent.com/k0kubun/hamlit/afcc2b36c4861c2f764baa09afd9530ca25eeafa/benchmark/graph/graph.png" width="600x" alt="Hamlit Benchmark" />

```
      hamlit v2.13.0:   247404.4 i/s
        erubi v1.9.0:   244356.4 i/s - 1.01x slower
         slim v4.1.0:   238254.3 i/s - 1.04x slower
         faml v0.8.1:   197293.2 i/s - 1.25x slower
         haml v5.2.0:   127834.4 i/s - 1.94x slower
```

### Why is Hamlit faster?

#### Less string concatenation by design
As written in [limitations](REFERENCE.md#limitations), Hamlit drops some not-so-important features which require
works on runtime. With the optimized language design, we can reduce the string concatenation
to build attributes.

#### Static analyzer
Hamlit analyzes Ruby expressions with Ripper and render it on compilation if the expression
is static. And Hamlit can also compile string literal with string interpolation to reduce
string allocation and concatenation on runtime.

#### C extension to build attributes
While Hamlit has static analyzer and static attributes are rendered on compilation,
dynamic attributes must be rendered on runtime. So Hamlit optimizes rendering on runtime
with C extension.

## Usage

Hamlit currently supports Ruby 2.1 and higher. See [REFERENCE.md](REFERENCE.md) for detail features of Hamlit.

### Rails

Add this line to your application's Gemfile or just replace `gem "haml"` with `gem "hamlit"`.
It enables rendering by Hamlit for \*.haml automatically.

```rb
gem 'hamlit'
```

If you want to use view generator, consider using [hamlit-rails](https://github.com/mfung/hamlit-rails).

### Sinatra

Replace `gem "haml"` with `gem "hamlit"` in Gemfile, and require "hamlit".

While Haml disables `escape_html` option by default, Hamlit enables it for security.
If you want to disable it, please write:

```rb
set :haml, { escape_html: false }
```


## Command line interface

You can see compiled code or rendering result with "hamlit" command.

```bash
$ gem install hamlit
$ hamlit --help
Commands:
  hamlit compile HAML    # Show compile result
  hamlit help [COMMAND]  # Describe available commands or one specific command
  hamlit parse HAML      # Show parse result
  hamlit render HAML     # Render haml template
  hamlit temple HAML     # Show temple intermediate expression

$ cat in.haml
- user_id = 123
%a{ href: "/users/#{user_id}" }

# Show compiled code
$ hamlit compile in.haml
_buf = [];  user_id = 123;
; _buf << ("<a href='/users/".freeze); _buf << (::Hamlit::Utils.escape_html((user_id))); _buf << ("'></a>\n".freeze); _buf = _buf.join

# Render html
$ hamlit render in.haml
<a href='/users/123'></a>
```

## Contributing

### Test latest version

```rb
# Gemfile
gem 'hamlit', github: 'k0kubun/hamlit', submodules: true
```

### Development

Contributions are welcomed. It'd be good to see
[Temple's EXPRESSIONS.md](https://github.com/judofyr/temple/blob/v0.7.6/EXPRESSIONS.md)
to learn Temple which is a template engine framework used in Hamlit.

```bash
$ git clone --recursive https://github.com/k0kubun/hamlit
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

### Coding styles

Please follow the existing coding styles and do not send patches including cosmetic changes.

## License

Copyright (c) 2015 Takashi Kokubun
