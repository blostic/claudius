require './Node.rb'

class ForEachNode < Node
	attr_accessor :parameters, :is_asynchronously
	def initialize (parent, block, parameters)
		super(parent, block)
		self.parameters = parameters
		self.is_asynchronously = false;
	end
end