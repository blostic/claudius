require 'node.rb'
require 'graph'

class ConcurrentNode < Node
      attr_accessor :instance

    def initialize (parent, block)
        super(parent, block)
    end

    def run(instance)
        pids = []
        totalTime =
            {
                :name => self.name,
                :before => 0,
                :exec => [],
                :after => 0
            }

        start = Time.now
        before_list.each do |before_command|
          if instance.nil?
            puts `"#{before_command}"`
          else
            $virtual_machines[instance].invoke [[before_command]]
          end
        end
        finish = Time.now

        totalTime[:before] = finish - start

        node_list.each do |node|
          pids << fork do
            totalTime[:exec].push(node.run(instance))
          end
        end

        pids.each{|pid| Process.waitpid(pid)}

        start = Time.now
        after_list.each do |after_command|
          if instance.nil?
            puts `"#{after_command}"`
          else
            $virtual_machines[instance].invoke [[after_command]]
          end
        end
        finish = Time.now

        totalTime[:after] = finish - start
        return totalTime
    end

    def draw_block(graph)
      graph.component << graph.node(self.id)
      graph.node(self.id).label('Concurrently')
    end

end