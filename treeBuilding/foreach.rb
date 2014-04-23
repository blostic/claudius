require "./For_Each_Node.rb"
require "./On_Node.rb"
require "./Execution_Block.rb"

$tmp_node;
$tmp_parent = nil;
$tmp_asynchronously = false;
$tmp_safely = false;
$tmp_execution_place = "localhost"

$root;
$current_scope;


def experiment(name, &block)
	puts 'experiment'
	$root = Node.new(nil,block);
	$current_scope = $root
	$tmp_parent = $root
	block.call;
end

def asynchronously()
	puts "should be concurrently"
	$tmp_asynchronously = true;
end

def safely()
	puts "should be safely"
	$tmp_safely = true;
end

def before(*args, &block)
	$tmp_node.before_list.push(block)
	#block.call
end

def after(&block)
	$tmp_node.after_list.push(block)
	# block.call
end

def foreach(*args, &block)
	parameters = args.first
	$tmp_node = For_Each_Node.new($tmp_parent, parameters, block)
	$tmp_node.is_safely = $tmp_safely
	$tmp_node.is_asynchronously = $tmp_asynchronously
	
	$tmp_safely = false;
	$tmp_asynchronously = false
	
	$tmp_parent.node_list.push($tmp_node)
	
	$tmp_parent = $tmp_node
	parameters.each do |parameter|
		block.call parameter
	end
	$tmp_parent = $tmp_node.parent
end 

def on(*args, &block)
	instance = args.first
	$tmp_node = On_Node.new($tmp_parent, instance, block)
	$tmp_node.is_safely = $tmp_safely
	$tmp_node.is_asynchronously = $tmp_asynchronously
	
	$tmp_safely = false;
	$tmp_asynchronously = false
	
	previous_execution_place = $tmp_execution_place
	$tmp_execution_place = instance
	
	$tmp_parent.node_list.push($tmp_node)
	$tmp_parent = $tmp_node
	block.call
	$tmp_parent = $tmp_node.parent

	$tmp_execution_place = previous_execution_place
end

def execute(&block)
	$tmp_node = Execution_Block.new($tmp_parent, $tmp_execution_place, block)
	$tmp_node.is_safely = $tmp_safely
	$tmp_node.is_asynchronously = $tmp_asynchronously
	
	$tmp_safely = false;
	$tmp_asynchronously = false

	$tmp_parent.node_list.push($tmp_node)
	# block.call
end