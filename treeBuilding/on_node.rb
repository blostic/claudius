require './node.rb'

class OnNode < Node
	attr_accessor :instance
	def initialize (parent, block, instance)
		super(parent, block)
		self.instance = instance
	end
end