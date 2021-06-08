#!/usr/bin/env ruby

require 'bundler/setup'
require 'hamlit'
require 'faml'
require 'benchmark/ips'
require_relative '../utils/benchmark_ips_extension'

Benchmark.ips do |x|
  x.report("Faml::AB.build")      { Faml::AttributeBuilder.build("'", true, nil, {:id=>"book"},  id: %w[content active]) }
  x.report("Haml::AB.build_id") { Haml::AttributeBuilder.build_id(true, "book", %w[content active]) }
  x.compare!
end
