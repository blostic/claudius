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
    totalTime =
        {
          :name => self.name,
          :total => 0,
          :before => 0,
          :exec => {},
          :after => 0
        }

    start = Time.now
    commands.each_with_index do  |command, index|
      _start = Time.now
      $virtual_machines[instance].invoke [[command]]
      _finish = Time.now
      totalTime[:exec]["#{index}. " + command] = _finish - _start
    end
    finish = Time.now

    totalTime[:total] = finish - start
    return totalTime
  end

end