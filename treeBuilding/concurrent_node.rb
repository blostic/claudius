require './treeBuilding/node.rb'
require 'graph.rb'
class ConcurrentNode < Node
      attr_accessor :instance

    def initialize (parent, block)
        super(parent, block)
        self.name = 'Concurrently' + @@node_counter.to_s
    end

    def run(instance)
        pids = []

        before_list.each do |before_command|
          if instance.nil? then
            puts `"#{before_command}"`
          else
            $manual_instances[instance].invoke [[before_command]]
          end
        end

        node_list.each do |node|
          pids << fork do
            node.run(instance)
          end
        end

        pids.each{|pid| Process.waitpid(pid)}

        after_list.each do |after_command|
          if instance.nil? then
            puts `"#{after_command}"`
          else
            $manual_instances[instance].invoke [[after_command]]
          end
        end
    end
    #
    # def print_tree(graph)
    #   graph.edge('asd', 'stasd')
    # end

end