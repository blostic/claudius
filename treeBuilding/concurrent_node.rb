require './treeBuilding/node.rb'

class ConcurrentNode < Node
    attr_accessor :instance

    def initialize (parent, block)
        super(parent, block)
    end

    def run(indent, instance)
        pids = []

        before_list.each do |before|
          print ' ' * indent
          before.call
        end

        node_list.each do |node|
          pids << fork do
            node.run(indent+2, instance)
          end
        end

        pids.each{|pid| Process.waitpid(pid)}

        after_list.each do |after|
          print ' ' * indent
          after.call
        end
    end
end