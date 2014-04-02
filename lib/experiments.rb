$mainExperiment = Wrapper.new

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

def experiments(&block)
	puts "Start: experiments"
  	yield
	puts "End: experiments"
end

def initiate(&block)
	puts "Initiatig"
	$mainExperiment.before = block
	yield
end

def clean(&block)
	puts "cleaning"
	$mainExperiment.after = block
	yield
end

def startBenchmarking
	puts "BENCHMARKING"
  	$mainExperiment.before.call
  	performExperiments
  	$mainExperiment.after.call
end
