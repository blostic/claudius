module Cloudmate
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

  class OnNode < Node
    attr_accessor :instance
    def initialize (parent, instance, block)
      super(parent, block)
      self.instance = instance
    end

    def run(instance)
      instance = @instance
      before_list.each do |before_command|
        puts before_command
        if instance.nil? then
          `#{before_command}`
        else
          $manual_instances[instance].invoke [[before_command]]
        end
      end

      node_list.each do |node|
        node.run(@instance)
      end

      after_list.each do |after_command|
        if instance.nil? then
          `#{after_command}`
        else
          $manual_instances[instance].invoke [[after_command]]
        end
      end
    end
  end

  class ConcurrentNode < Node
    attr_accessor :instance

    def initialize (parent, block)
      super(parent, block)
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
  end

  class ExecutionNode < Node
    attr_accessor :execution_instance
    def initialize (parent, block)
      super(parent, block)
      self.execution_instance = execution_instance
    end

    def run(instance)
      # commands.each do |command|
      #   $manual_instances[instance].invoke [[command]]
      # end
      $manual_instances[instance].invoke [commands]
    end
  end
end
