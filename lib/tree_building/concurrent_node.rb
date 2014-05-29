require 'node.rb'
require 'graph.rb'

class ConcurrentNode < Node
      attr_accessor :instance

    def initialize (parent, block)
        super(parent, block)
    end

    def run(instance)
        pids = []

        before_list.each do |before_command|
          if instance.nil?
            puts `"#{before_command}"`
          else
            $virtual_machines[instance].invoke [[before_command]]
          end
        end

        node_list.each do |node|
          pids << fork do
            node.run(instance)
          end
        end

        pids.each{|pid| Process.waitpid(pid)}

        after_list.each do |after_command|
          if instance.nil?
            puts `"#{after_command}"`
          else
            $virtual_machines[instance].invoke [[after_command]]
          end
        end
    end

    def draw_block(graph)
      graph.component << graph.node(self.id)
      graph.node(self.id).label('Concurrently')
    end

end