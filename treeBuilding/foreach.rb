require "./For_Each_Node.rb"
require "./On_Node.rb"
require "./Execution_Block.rb"

$child_node;
$current_node = nil;
$tmp_asynchronously = false;
$tmp_safely = false;
$tmp_execution_place = "localhost"

$root;


def experiment(name, &block)
	puts 'experiment'
	$root = Node.new(nil,block)
	$current_node = $root
	block.call
end

def asynchronously()
	 puts "should be concurrently"
	$tmp_asynchronously = true;
end

def safely()
	 puts "should be safely"
	$tmp_safely = true
end

def before(*args, &block)
	$current_node.before_list.push(block)
	# block.call
end

def after(&block)
	$current_node.after_list.push(block)
	# block.call
end

def foreach(*args, &block)
	parameters = args.first

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

def on(*args, &block)
	instance = args.first
	$child_node = On_Node.new($current_node, instance, block)
	$child_node.is_safely = $tmp_safely
	$child_node.is_asynchronously = $tmp_asynchronously

	$tmp_safely = false
	$tmp_asynchronously = false

	previous_execution_place = $tmp_execution_place
	$tmp_execution_place = instance

	$current_node.node_list.push($child_node)
	$current_node = $child_node
	block.call
	$current_node = $current_node.parent

	$tmp_execution_place = previous_execution_place
end

def execute(&block)
  $child_node = Execution_Block.new($current_node, $tmp_execution_place, block)
	$child_node.is_safely = $tmp_safely
	$child_node.is_asynchronously = $tmp_asynchronously


	$tmp_safely = false
	$tmp_asynchronously = false

	$current_node.node_list.push($child_node)
end