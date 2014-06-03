require 'concurrent_node.rb'
require 'on_node.rb'
require 'execution_node.rb'

def experiment(name, &block)
  experiment = Experiment.new(name, &block)
end

class Experiment
  #attr_accessor :child_node

  $child_node
  $current_node = nil
  $tmp_asynchronously = false
  $tmp_safely = false
  $tmp_execution_place = 'localhost'
  $in_after_scope = false
  $in_before_scope = false

  $root

  def initialize(name, &block)
    $root = Node.new(nil,block)
    $current_node = $root
    $root.name = name
    instance_eval(&block) if block
    $root.print_tree
    run_with_time
  end

  def asynchronously
     $child_node = ConcurrentNode.new($current_node, nil)
     $current_node.node_list.push($child_node)
     $current_node = $child_node
  end

  def safely
       puts 'should be safely'
  end

  def before(*args, &block)
    $in_before_scope = true
    yield
    $in_before_scope = false
  end

  def after(*args, &block)
      $in_after_scope = true
      yield
      $in_after_scope = false
  end

  def foreach(parameters, *args, &block)
    puts $current_node.name
    parameters.each do |parameter|
      $child_node = Node.new($current_node, block)
      $child_node.is_safely = $tmp_safely
      $child_node.is_asynchronously = $tmp_asynchronously
      $current_node.node_list.push($child_node)
      $current_node = $child_node
      block.call parameter
      $current_node = $current_node.parent
    end
  end

  def on(instance, *args, &block)
    $child_node = OnNode.new($current_node, instance, block)

    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def concurrent(*args, &block)
    $child_node = ConcurrentNode.new($current_node, block)
    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def execute(*args, &block)
    $child_node = ExecutionNode.new($current_node, block)
    $child_node.is_safely = $tmp_safely
    $child_node.is_asynchronously = $tmp_asynchronously
    $current_node.node_list.push($child_node)
    $current_node = $child_node
    block.call
    $current_node = $current_node.parent
  end

  def ssh(command)
    if $in_before_scope
      $current_node.before_list.push(command)
    elsif $in_after_scope
      $current_node.after_list.push(command)
    else
      $current_node.commands.push(command)
    end
  end

  def run_with_time
    result = $root.run(nil)
    awesome_print result
    return result
  end

end