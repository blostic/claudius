$mainExperiment = Experiment.new

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
		puts "I received the instance type: " + type
	end
end

def experiments(&block)
  	yield
end

def initiate(&block)
	$mainExperiment.before = block
end

def clean(&block)
	$mainExperiment.after = block
end

def performExperiments
	i=0
	for experiment in $experiments
		i +=1
		puts "[Starting #{i} experiment]"
		experiment.perform
	end
end

