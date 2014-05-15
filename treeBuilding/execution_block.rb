require './treeBuilding/node.rb'
require './remote_execution/provider.rb'

class ExecutionBlock < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
	end

	def run(instance)
    # commands.each do |command|
    #   $manual_instances[instance].invoke [[command]]
    # end
    $manual_instances[instance].invoke [commands]
	end
end