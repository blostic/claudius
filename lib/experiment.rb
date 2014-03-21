#!/usr/bin/env ruby

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

def install (&block)
	puts "Removing old packages" 
	puts `sudo apt-get autoremove`
	puts "Old packages removed" 
	yield
end

def package (package, repository) 
	if repository != nil
		puts `sudo apt-get install #{package}`
	else
		puts "#{package}  : #{repository}"
		`sudo add-apt-repository`
		puts "Repository #{repository} added"
		`sudo apt-get update`
		`yes | sudo apt-get install #{package}`
		puts "package #{package} installed"
	end	
end


def instances(*types)
	for type in types
		puts "Otrzymany typ instancji: " + type
	end
end

def benchmark(benchmarkName, &block)
	puts "Start: #{benchmarkName} benchmark"
  	yield
	puts "End: #{benchmarkName} benchmark"
end

def experiments(&block)
	puts "Start: experiments"
  	yield
	puts "End: experiments"
end

def experiment(experimentName, &block)
	puts "Start: #{experimentName} experiment"
  	yield
	puts "End: #{experimentName} experiment"
end


def beforeEach(&block)
	puts "before each"
	yield
end

def afterEach(&block)
	puts "after each"
	yield
end

def execution(&block)
	puts "Start: execution"
  	yield
	puts "End: execution"
end

def initiate(&block)
	puts "initiatig"
	yield
end

def clean(&block)
	puts "cleaning"
	yield
end

def parameters(&block)
	puts "Start: execution"
  	yield
	puts "End: execution"
end

def parameter(name, array)
	puts "name: #{name} in #{array}"
end

