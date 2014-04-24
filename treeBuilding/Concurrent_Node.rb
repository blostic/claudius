require './Node.rb'

class Concurrent_Node < Node
    attr_accessor :instance
    def initialize (parent, block)
        super(parent, block)
    end

        def run(indent)
            pids = []

            for before in @before_list do
                print " "*indent 
                before.call
            end

            for node in @node_list do
                pids << fork do
                    node.run(indent+2)
                end
            end
            pids.each{|pid| Process.waitpid(pid)}

            for after in @after_list do
                print " "*indent 
                after.call
            end
    end
end