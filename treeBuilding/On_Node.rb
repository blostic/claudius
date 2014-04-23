require './Node.rb'

class On_Node < Node
	attr_accessor :instance
	def initialize (parent, block, instance)
		super(parent, block)
		self.instance = instance
	end
end