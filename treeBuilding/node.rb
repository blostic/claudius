require 'graph.rb'

class Node
  @@node_counter = 0

  attr_accessor :parent, :code_block, :is_safely, :node_list,
                :before_list, :after_list, :is_asynchronously, :exec_block, :commands, :name, :number

  def initialize(parent, block)
    self.parent = parent
    self.code_block = block
    self.node_list = Array.new
    self.before_list = Array.new
    self.after_list = Array.new
    self.is_safely = false
    self.is_asynchronously = false
    self.commands = Array.new
    self.name = 'Node' + @@node_counter.to_s
    self.number = @@node_counter
    @@node_counter+=1
  end

  def run(instance)
    before_list.each do |before_command|
      if instance.nil?
        puts `"#{before_command}"`
      else
        $manual_instances[instance].invoke [[before_command]]
      end
    end

    node_list.each do |node|
      node.run(instance)
    end

    after_list.each do |after_command|
      if instance.nil?
        puts `#{after_command}`
      else
        $manual_instances[instance].invoke [[after_command]]
      end
    end
  end

  def draw_block(graph)
    graph.rect << graph.node(self.name)
  end

  def draw_before_blocks(node, graph)
    if node.before_list.length > 0
      name = '[BEFORE] '+"#{node.number}\n"
      node.before_list.each do |before|
        name += ">#{before}\n"
      end
      graph.rect << graph.node(name)
      graph.green << graph.edge(node.name, name)
    end
  end

  def draw_after_blocks(node, graph)
    if node.after_list.length > 0
      name = '[AFTER] '+"#{node.number}\n"
      node.after_list.each do |after|
        name += ">#{after}\n"
      end
      graph.rect << graph.node(name)
      graph.red << graph.edge(node.name, name)
    end
  end

  def draw_child_nodes(node, graph)
    node.node_list.each do |child_node|
      child_node.commands.each do |command|
        child_node.name += "\n >" +command.to_s
      end
      graph.edge(node.name, child_node.name)
      paint(child_node, graph)
    end
  end

  def paint(node, graph)
    node.draw_block(graph)
    draw_before_blocks(node, graph)
    draw_child_nodes(node, graph)
    draw_after_blocks(node, graph)
  end

  def print_tree
    node = self
    digraph do
      node.paint(node, self)
      save 'execution_graph', 'png'
    end
  end

end
