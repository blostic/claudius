class Node

	attr_accessor :parent, :code_block, :is_safely, :node_list, 
				  :before_list, :after_list, :before_each_list, :after_each_list

	def initialize(parent, block)
		self.parent = parent
		self.code_block = block
		self.is_safely = false
		self.node_list = Array.new
		self.before_list = Array.new
		self.after_list = Array.new
		self.before_each_list = Array.new
		self.after_each_list = Array.new
	end

end
