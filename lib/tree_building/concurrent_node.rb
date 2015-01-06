require 'node.rb'
require 'graph'

class ConcurrentNode < Node
      attr_accessor :instance

    def initialize (parent, block)
        super(parent, block)
    end

    def run(instance)
        pids = []
        init_time

        before_exec(instance, @total_time)

        node_list.each do |node|
          pids << fork do
            @total_time[:exec].push(node.run(instance))
          end
        end

        pids.each{|pid| Process.waitpid(pid)}

        after_exec(instance, @total_time)
        @total_time
    end

    def draw_block(graph)
      graph.component << graph.node(self.id)
      graph.node(self.id).label('Concurrently')
    end

end