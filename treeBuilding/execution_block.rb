require './node.rb'

class ExecutionBlock < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
	end

	def run(indent)
		print ' '*indent
		code_block.call
	end
end