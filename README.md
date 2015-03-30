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

Hamlit's rendering is **7.0x times faster** than original haml.

```
   hamlit:    94047.0 i/s
   erubis:    87136.3 i/s - 1.08x slower
     slim:    83996.0 i/s - 1.12x slower
     faml:    68861.1 i/s - 1.37x slower
     haml:    13428.6 i/s - 7.00x slower
```

[This benchmark](https://github.com/k0kubun/hamlit/blob/6d7d5ca7601dad9fe04d67621255ac2a69cd8d85/benchmarks/benchmark.rb)
is the same as [slim-template/slim](https://github.com/slim-template/slim)'s one for fairness.

### Better parser

Haml's attribute parser is not so good. For example, raises syntax error for `%a{ b: '}' }`.
Hamlit's attribute parser is implemented with Ripper, which is an official lexer for Ruby,
so it can able to parse such an attribute.

### Passing haml-spec

[haml/haml-spec](https://github.com/haml/haml-spec) is a basic suite of tests for Haml interpreters.
For all test cases in haml-spec, Hamlit behaves the same as Haml (ugly mode only, which is used on production).

## License

MIT License
