require './Node.rb'

class ForEachNode < Node
	attr_accessor :parameters, :isAsynchronously
	def initialize (parent, block, parameters)
		super(parent, block)
		self.parameters = parameters
		self.isAsynchronously = false;
	end
end