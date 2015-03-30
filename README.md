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

Hamlit's rendering is **8.47x times faster** than original haml.

```
    hamlit:   133922.9 i/s
    erubis:   123464.1 i/s - 1.08x slower
      slim:   110404.3 i/s - 1.21x slower
      faml:    92009.3 i/s - 1.46x slower
      haml:    15810.4 i/s - 8.47x slower
```

[This benchmark](https://github.com/k0kubun/hamlit/blob/74ede1101f228828e343ceb1af481c45eaf0a1dd/benchmarks/benchmark.rb)
is the same as [slim-template/slim](https://github.com/slim-template/slim)'s one for fairness.
([The result on travis CI](https://travis-ci.org/k0kubun/hamlit/jobs/56403724))

### Better parser

Haml's attribute parser is not so good. For example, raises syntax error for `%a{ b: '}' }`.
Hamlit's attribute parser is implemented with Ripper, which is an official lexer for Ruby,
so it can able to parse such an attribute.

### Passing haml-spec

[haml/haml-spec](https://github.com/haml/haml-spec) is a basic suite of tests for Haml interpreters.
For all test cases in haml-spec, Hamlit behaves the same as Haml (ugly mode only, which is used on production).

## License

MIT License
