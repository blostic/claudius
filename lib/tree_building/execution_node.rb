require 'node.rb'
require 'provider.rb'

class ExecutionNode < Node
	attr_accessor :execution_instance
	def initialize (parent, block)
		super(parent, block)
		self.execution_instance = execution_instance
    self.name = '[' + ExecutionNode.to_s + ']'
  end


  def init_time
    @total_time =
        {
            :name => @name,
            :before => 0,
            :exec => [],
        }
  end

  def draw_block(graph)
    graph.rect << graph.node(id)
    graph.node(id).label(name)
  end


  def run(instance)
    init_time

    start = Time.now
    commands.each_with_index do  |command, index|
      _start = Time.now
      if instance.nil? or instance == 'localhost'
        puts `#{command}`
      else
        $virtual_machines[instance].invoke [[command]]
      end
      _finish = Time.now
      @total_time[:exec].push( {:cmd => command, :time => _finish - _start})
    end
    finish = Time.now

    @total_time[:total] = finish - start
    return @total_time
  end

end