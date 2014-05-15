
class Node

    attr_accessor :parent, :code_block, :is_safely, :node_list, 
    :before_list, :after_list, :is_asynchronously, :exec_block, :commands

    def initialize(parent, block)
        self.parent = parent
        self.code_block = block
        self.node_list = Array.new
        self.before_list = Array.new
        self.after_list = Array.new
        self.is_safely = false
        self.is_asynchronously = false
        self.commands = Array.new
    end

    def run(instance)
      before_list.each do |before_command|
        if instance.nil? then
          puts `"#{before_command}"`
        else
          $manual_instances[instance].invoke [[before_command]]
        end
      end

      node_list.each do |node|
        node.run(instance)
      end

      after_list.each do |after_command|
        if instance.nil? then
           puts `#{after_command}`
        else
          $manual_instances[instance].invoke [[after_command]]
        end
      end
    end
end

