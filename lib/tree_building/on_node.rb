require 'node.rb'

class OnNode < Node
	attr_accessor :instance
	def initialize (parent, instance, block)
		super(parent, block)
		self.instance = instance
    self.name = "[OnNode]\n" + instance
  end

  def run(instance)
    instance = @instance
    before_list.each do |before_command|
      puts before_command
      if instance.nil?
        `#{before_command}`
      else
        $virtual_machines[instance].invoke [[before_command]]
      end
    end

    node_list.each do |node|
      puts @instance
      node.run(@instance)
    end

    after_list.each do |after_command|
      if instance.nil?
        `#{after_command}`
      else
        $virtual_machines[instance].invoke [[after_command]]
      end
    end
  end

  def draw_block(graph)
    graph.component << graph.node(id)
    graph.node(id).label(name)
  end

end