class Node

	attr_accessor :parent, :codeBlock, :isSafely, :nodeList, 
				  :beforeList, :afterList, :beforeEachList, :afterEachList

	def initialize(parent, block)
		self.parent = parent
		self.codeBlock = block
		self.isSafely = false
		self.nodeList = Array.new
		self.beforeList = Array.new
		self.afterList = Array.new
		self.beforeEachList = Array.new
		self.afterEachList = Array.new
	end

end
