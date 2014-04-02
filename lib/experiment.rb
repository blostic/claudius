require './Wrapper'

$experiments = Array.new

def experiment(experimentName, &block)
	$experiments.push Wrapper.new
	puts "Start: #{experimentName} experiment"
  	yield
	puts "End: #{experimentName} experiment"
end

def parameters(&block)
	puts "Start: execution"
  	yield
	puts "End: execution"
end

def parameter(name, array)
	puts "name: #{name} in #{array}"
end

def before(&block)
	puts "Update before method in #{$experiments.length} experiment"
	$experiments.last.before = block
end

def after(&block)
	puts "Update after method in #{$experiments.length} experiment"
	$experiments.last.after = block
end

def beforeEach(&block)
	puts "Update beforeEach method in #{$experiments.length} experiment"
end

def afterEach(&block)
	puts "Update afterEach method in #{$experiments.length} experiment"
end

def execute(&block)
	puts "Update exectution method in #{$experiments.length} experiment"
	$experiments.last.execute = block
end

def performExperiments
	i=0
	for experiment in $experiments
		i +=1
		puts "Starting #{i} experiment"
		experiment.perform
	end
end





