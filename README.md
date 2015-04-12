# Hamlit [![Build Status](https://travis-ci.org/k0kubun/hamlit.svg?branch=master)](https://travis-ci.org/k0kubun/hamlit)

Hamlit is a high performance [haml](https://github.com/haml/haml) implementation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hamlit'
```

or just replace `gem "haml"` with `gem "hamlit"`.

## Features
### Fast rendering

Hamlit's rendering is **7.24x times faster** than original haml.

```
    erubis:   114417.8 i/s
    hamlit:   107367.5 i/s - 1.07x slower
      slim:   104728.0 i/s - 1.09x slower
      faml:    87624.2 i/s - 1.31x slower
      haml:    15796.0 i/s - 7.24x slower
```

[This benchmark](https://github.com/k0kubun/hamlit/blob/b6f112aa1f51816ab9a3a81bd7810ed9cffd26aa/benchmarks/benchmark.rb)
is the same as [slim-template/slim](https://github.com/slim-template/slim)'s one for fairness.
([The result on travis CI](https://travis-ci.org/k0kubun/hamlit/jobs/57333515))

Note that there are [some incompatibilities](https://github.com/k0kubun/hamlit/issues) related to performance.
You may want [faml](https://github.com/eagletmt/faml) for a better compatibility.

### Better parser

Haml's attribute parser is not so good. For example, raises syntax error for `%a{ b: '}' }`.
Hamlit's attribute parser is implemented with Ripper, which is an official lexer for Ruby,
so it is able to parse such an attribute.

### Passing haml-spec

[haml/haml-spec](https://github.com/haml/haml-spec) is a basic suite of tests for Haml interpreters.
For all test cases in haml-spec, Hamlit behaves the same as Haml (ugly mode only, which is used on production).

Hamlit is used on [githubranking.com](http://githubranking.com/).

## Usage

Basically the same as [haml](https://github.com/haml/haml).
Check out the [reference documentation](http://haml.info/docs/yardoc/file.REFERENCE.html) for details.

### Rails, Sinatra

Just update Gemfile. Html escaping is enabled by default.

## Why high performance?
### Less work on runtime
Haml's rendering is very slow because generated code by haml runs many operations on runtime.
For example, Haml::Util is extended on view, attribute rendering runs even if it is a
static value and the values in attribute is sorted. All of them is achieved on runtime.

Hamlit extends ActionView beforehand, attribute rendering is done when compiled if it
is a static hash and no unnecessary operation is done on runtime.

### Temple optimizers
Hamlit is implemented with [temple](https://github.com/judofyr/temple), which is a template
engine framework for Ruby. Temple has some great optimizers for generated code. Thus generated
code by Hamlit is very fast.

Not only relying on temple optimizers, but also Hamlit's compiler cares about many cases
to optimize performance such as string interpolation.

## TODO

Currently there are some important incompatibilities that should be fixed.

- Remove falsy attributes [#2](https://github.com/k0kubun/hamlit/issues/2)

## License

MIT License
