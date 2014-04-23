require './Node.rb'

class For_Each_Node < Node
	attr_accessor :parameters
	def initialize (parent, block, parameters)
		super(parent, block)
		self.parameters = parameters
	end
end