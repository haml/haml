#!/usr/bin/env ruby

require 'bundler/setup'
require 'haml'
require 'benchmark/ips'
require_relative '../utils/benchmark_ips_extension'

Benchmark.ips do |x|
  x.report("Haml::AB.build_id") { Haml::AttributeBuilder.build_id(true, "book", %w[content active]) }
  x.compare!
end
