require './treeBuilding/node.rb'
require './remote_execution/provider.rb'

class ExecutionBlock < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
    self.name = "[" + ExecutionBlock.to_s + "] "
  end


  def draw_block(graph)
    graph.rect << graph.node(id)
    graph.node(id).label(name)
  end

  def run(indent, instance)
    commands.each do |command|
      $manual_instances[instance].invoke [[command]]
    end
    # $manual_instances[instance].invoke [commands]
		print ' '*indent
  end

	def run(instance)
    # commands.each do |command|
    #   $manual_instances[instance].invoke [[command]]
    # end
    $manual_instances[instance].invoke [commands]
  end

end