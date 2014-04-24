
class Node

    attr_accessor :parent, :code_block, :is_safely, :node_list, 
    :before_list, :after_list, :is_asynchronously, :exec_block

    def initialize(parent, block)
        self.parent = parent
        self.code_block = block
        self.node_list = Array.new
        self.before_list = Array.new
        self.after_list = Array.new
        self.is_safely = false
        self.is_asynchronously = false
    end

    def run(indent = 0)
        for before in @before_list do
            print " "*indent 
            before.call
        end

        for node in @node_list do
            node.run(indent+2)
        end

        for after in @after_list do
            print " "*indent 
            after.call
        end
    end

end

