require 'concurrent_node.rb'
require 'on_node.rb'
require 'foreach_node.rb'
require 'execution_node.rb'

def experiment(name, &block)
    Experiment.new(name, &block)
end

class Experiment
    def initialize(name, &block)
        @child_node
        @current_node = nil
        @tmp_concurrently = false
        @tmp_safely = false
        @tmp_execution_place = 'localhost'
        @in_after_scope = false
        @in_before_scope = false
        @root = Node.new(nil, block)
        @current_node = @root
        @root.name = name
        instance_eval(&block) if block
    end

    def concurrently
        @tmp_concurrently = true
    end

    def safely
        @tmp_safely = true
    end

    def concurrent(*args, &block)
        @child_node = ConcurrentNode.new(@current_node, block)
        @current_node.node_list.push(@child_node)
        @current_node = @child_node
        block.call
        @current_node = @current_node.parent
    end

    def before(*args, &block)
        @in_before_scope = true
        yield
        @in_before_scope = false
    end

    def after(*args, &block)
        @in_after_scope = true
        yield
        @in_after_scope = false
    end

    def foreach(parameters, *args, &block)

        @current_node = ForeachNode.new(@current_node, block)

        @current_node.is_safely = @tmp_safely
        @tmp_safely = false

        @current_node.is_concurrently = @tmp_concurrently
        @tmp_concurrently = false

        @current_node.parent.node_list.push(@current_node)

        parameters.each do |parameter|
            @child_node = Node.new(@current_node, block)
            @child_node.name = "Parameter: #{parameter}"
            @current_node.node_list.push(@child_node)
            @current_node = @child_node
            block.call parameter
            @current_node = @current_node.parent
        end

        @current_node = @current_node.parent
    end

    def on(instance, *args, &block)o
        @child_node = OnNode.new(@current_node, instance, block)

        @current_node.node_list.push(@child_node)
        @current_node = @child_node
        block.call
        @current_node = @current_node.parent
    end

    def execute(*args, &block)
        @child_node = ExecutionNode.new(@current_node, block)
        @child_node.is_safely = @tmp_safely
        @child_node.is_concurrently = @tmp_concurrently
        @current_node.node_list.push(@child_node)
        @current_node = @child_node
        block.call
        @current_node = @current_node.parent
    end

    def ssh(command)
        if @in_before_scope
            @current_node.before_list.push(command)
        elsif @in_after_scope
            @current_node.after_list.push(command)
        else
            @current_node.commands.push(command)
        end
    end

    def run
        begin
            @root.run(nil)
        rescue
            '{error : true}'
        end
    end

    def destroy_machines
        if $vms_manager
            $vms_manager.destroy_machines
        end
    end

    def export_tree(path = 'execution_tree')
        @root.print_tree(path)
    end

end