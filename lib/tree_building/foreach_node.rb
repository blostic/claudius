require 'node.rb'

class ForeachNode < Node
    def initialize (parent, block)
        super(parent, block)
        self.name = "[Foreach]\n"
    end

    def run(instance)
        init_time
        before_exec(instance, @total_time)
        begin
            if is_concurrently
                pids = []
                node_list.each do |node|
                    pids << fork do
                        @total_time[:exec].push(node.run(instance))
                    end
                end
                pids.each{|pid| Process.waitpid(pid)}
            else
                node_list.each do |node|
                    @total_time[:exec].push(node.run(@instance))
                end
            end
        rescue
            if is_safely
                raise "An error has occured"
            end
        end
        after_exec(@instance, @total_time)
        @total_time
    end

    def draw_block(graph)
        graph.hexagon << graph.node(id)
        graph.node(id).label(name + 'Concurrently: ' + is_concurrently.to_s + '\nSafely: ' + is_safely.to_s)
    end

end