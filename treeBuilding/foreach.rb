require './ForEachNode.rb'

$list = []
$tmp_node;
$tmp_parent = nil;
$tmp_asynchronously = false;
$tmp_safely = false;

def foreach(*args, &block)
	parameters = args.first
	tmp_node = ForEachNode.new($tmp_parent, parameters, block)
	tmp_node.isSafely = $tmp_safely
	tmp_node.parent = $tmp_parent
	tmp_node.isAsynchronously = $tmp_asynchronously
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
	puts "should be concurrently"
	$tmp_asynchronously = true;
end

def safely()
	puts "should be safely"
	$tmp_safely = true;
end

for element in $list
	print "[asyn: ", element.isAsynchronously, ", safely: ", element.isSafely, "]\n"
end