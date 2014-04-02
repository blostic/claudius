class Experiment
	attr_accessor :before, :after, :execute, :before_each, :after_each;	
	
  def initialize
      @execute = Array.new
      @before_each = Proc.new{}
      @after = Proc.new{}
      @before = Proc.new{}
      @before_each = Proc.new{}
      @after_each = Proc.new{}
  end

	def perform		
			before.call
      for task in execute do 
        before_each.call
        task.call
        after_each.call
      end
			after.call
	end

end

$experiments = Array.new

def experiment(experimentName, &block)
	$experiments.push Experiment.new
  	yield
end

def parameters(&block)
	puts "In parameters block"
  	yield
end

def parameter(name, array)
	puts "Parameter name: #{name} in #{array}"
end

def before(&block)
	puts "Update before method in #{$experiments.length} experiment"
	$experiments.last.before = block
end

def after(&block)
	puts "Update after method in #{$experiments.length} experiment"
	$experiments.last.after = block
end

def before_each(&block)
	puts "Update before_each method in #{$experiments.length} experiment"
	$experiments.last.before_each = block
end

def after_each(&block)
	puts "Update after_each method in #{$experiments.length} experiment"
	$experiments.last.after_each = block
end

def execute(&block)
	puts "Update exectution method in #{$experiments.length} experiment"
	$experiments.last.execute.push(block)
end


