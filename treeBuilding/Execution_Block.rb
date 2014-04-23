require './Node.rb'

class Execution_Block < Node
	attr_accessor :execution_instance
	def initialize (parent, execution_instance, block)
		super(parent, block)
		self.execution_instance = execution_instance
	end
end