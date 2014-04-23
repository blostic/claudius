require './Node.rb'


$list = []
$tmp_node;
$tmp_parent = nil;
$tmp_asynchronously = false;
$tmp_safely = false;

$root_scope;
$current_scope;

def experiment(name, &block)
	puts 'experiment'
	$root_scope = Node.new(nil,block);
	$current_scope = $root_scope;	
	block.call;
end

def before(name, properties, &block)
	puts 'before';
	$current_scope.before_list.push(block);	
	block.call;
end

def after(&block)
	puts 'after';
	$current_scope.after_list.push(block);	
end

def on(instance, &block)
	puts 'Delegate code to VM: ' + instance	
	yield
end

def foreach(*args, &block)
	puts args
	parameters = args.first
	tmp_node = ForEachNode.new($tmp_parent, parameters, block)
	tmp_node.is_safely = $tmp_safely
	tmp_node.parent = $tmp_parent
	tmp_node.is_asynchronously = $tmp_asynchronously
	$tmp_parent = tmp_node

	$tmp_safely = false;
	$tmp_asynchronously = false

	$list.push(tmp_node)
	parameters.each do |parameter|
		block.call parameter
	end
	$tmp_parent = tmp_node.parent
end 

def asynchronously()
	# puts "should be concurrently"
	# $tmp_asynchronously = true;
end

def safely()
	# puts "should be safely"
	# $tmp_safely = true;
end

def concurrent(&block)
	puts "CONCURRENT"
	yield
	puts "END CONCURRENT"
end