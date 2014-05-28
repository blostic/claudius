require 'node.rb'
require 'provider.rb'

class ExecutionNode < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
    self.name = '[' + ExecutionNode.to_s + ']'
  end

  def draw_block(graph)
    graph.rect << graph.node(id)
    graph.node(id).label(name)
  end

  def run(instance)
    commands.each do |command|
      $virtual_machines[instance].invoke [[command]]
    end
  end

end