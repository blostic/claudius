require 'node.rb'

class OnNode < Node
	attr_accessor :instance
	def initialize (parent, instance, block)
		super(parent, block)
		self.instance = instance
    self.name = "[OnNode]\n" + instance
  end

  def run(instance)
    totalTime =
        {
            :name => self.name,
            :before => 0,
            :exec => [],
            :after => 0
        }
    instance = @instance

    start = Time.now
    before_list.each do |before_command|
      puts before_command
      if instance.nil?
        `#{before_command}`
      else
        $virtual_machines[instance].invoke [[before_command]]
      end
    end
    finish = Time.now

    totalTime[:before] = finish - start

    node_list.each do |node|
      puts @instance
      totalTime[:exec].push(node.run(@instance))
    end


    start = Time.now
    after_list.each do |after_command|
      if instance.nil?
        `#{after_command}`
      else
        $virtual_machines[instance].invoke [[after_command]]
      end
    end
    finish = Time.now

    totalTime[:after] = finish - start

    return totalTime
  end

  def draw_block(graph)
    graph.component << graph.node(id)
    graph.node(id).label(name)
  end

end