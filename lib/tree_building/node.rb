require 'graph.rb'
require 'awesome_print'

class Node
  attr_accessor :parent, :code_block, :is_safely, :node_list,
                :before_list, :after_list, :is_concurrently, :is_safely,
                :exec_block, :commands, :name, :id

  def initialize(parent, block)
    self.parent = parent
    self.code_block = block
    self.node_list = Array.new
    self.before_list = Array.new
    self.after_list = Array.new
    self.is_safely = false
    self.is_concurrently = false
    self.commands = Array.new
    self.id = self.to_s
    self.name = '[Node]'
  end

  def init_time
    @total_time =
        {
            :name => @name,
            :exec => []
        }
  end

  def run(instance)
    init_time
    before_exec(instance, @total_time)
    node_list.each do |node|
      @total_time[:exec].push(node.run(instance))
    end
    after_exec(instance, @total_time)

    return @total_time
  end

  def before_exec(instance, total_time)
    start = Time.now
    before_list.each do |before_command|
      if instance.nil?
        puts `#{before_command}`
      else
        $virtual_machines[instance].invoke [[before_command]]
      end
    end
    finish = Time.now

    total_time[:before] = finish - start
  end

  def after_exec(instance, total_time)
    start = Time.now
    after_list.each do |after_command|
      if instance.nil?
        puts `#{after_command}`
      else
        $virtual_machines[instance].invoke [[after_command]]
      end
    end
    finish = Time.now
    total_time[:after] = finish - start
  end

  def draw_block(graph)
    graph.rect << graph.node(self.id)
    graph.node(self.id).label(name)
  end

  def draw_before_blocks(node, graph)
    if node.before_list.length > 0
      id = Random.rand(2**64)
      name = "[BEFORE]\n"
      node.before_list.each do |before|
        name += ">#{before}\n"
      end
      graph.rect << graph.node(id)
      graph.green << graph.edge(node.id, id)
      graph.node(id).label(name)
    end
  end

  def draw_after_blocks(node, graph)
    if node.after_list.length > 0
      id = Random.rand(2**64)
      name = "[AFTER]\n"
      node.after_list.each do |after|
        name += ">#{after}\n"
      end
      graph.rect << graph.node(id)
      graph.red << graph.edge(node.id, id)
      graph.node(id).label(name)
    end
  end

  def draw_child_nodes(node, graph)
    node.node_list.each do |child_node|
      child_node.commands.each do |command|
        child_node.name += "\n >" +command.to_s
      end
      graph.edge(node.id, child_node.id)
      paint(child_node, graph)
    end
  end

  def paint(node, graph)
    node.draw_block(graph)
    draw_before_blocks(node, graph)
    draw_child_nodes(node, graph)
    draw_after_blocks(node, graph)
  end

  def print_tree(path)
    node = self
    digraph do
      node.paint(node, self)
      save path, 'png'
    end
  end

end
