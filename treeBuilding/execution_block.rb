require './treeBuilding/node.rb'
require './remote_execution/provider.rb'

class ExecutionBlock < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
    self.name = Random.rand(1000000000000000000000000000).to_s #"[" + ExecutionBlock.to_s + "] " + self.number.to_s
  end

  def draw_block(graph)
    id = Random.rand(1000000000000000000000000000)
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