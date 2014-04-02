#!/usr/bin/env ruby
require './experiment'
require './experiments'

def benchmark(benchmarkName, &block)
	puts "Start: #{benchmarkName} benchmark"
  	yield
	puts "End: #{benchmarkName} benchmark"
	startBenchmarking
end

def provider (text, &block)
	puts "I get a provider " + text
	yield
	puts "I end a provider " + text

end

def aws_access_key_id(text)
	puts "I get aws_access_key_id: #{text}"
end

def providers(&block)
	puts "In providers block"
	yield
	puts "Out providers block"

end
