#!/usr/bin/env ruby
require './experiment'
require './experiments'

def benchmark(benchmarkName, &block)
	puts "[Start] #{benchmarkName} benchmark"
  	yield
	start_benchmarking
	puts "[End] #{benchmarkName} benchmark"
end

def provider (text, &block)
	puts "I get a provider " + text
	yield
end

def aws_access_key_id(text)
	puts "I get aws_access_key_id: #{text}"
end

def providers(&block)
	puts "In providers block"
	yield
end

def start_benchmarking
	puts "\nBENCHMARK\n\n"
  	$mainExperiment.before.call
  	performExperiments
  	$mainExperiment.after.call
end
