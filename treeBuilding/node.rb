require 'graph.rb'

class Node
  @@node_counter = 0

  attr_accessor :parent, :code_block, :is_safely, :node_list,
    :before_list, :after_list, :is_asynchronously, :exec_block, :commands, :name, :number

    def initialize(parent, block)
      self.parent = parent
      self.code_block = block
      self.node_list = Array.new
      self.before_list = Array.new
      self.after_list = Array.new
      self.is_safely = false
      self.is_asynchronously = false
      self.commands = Array.new
      self.name = 'Node' + @@node_counter.to_s
      self.number = @@node_counter
      @@node_counter+=1
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

    def print_tree(graph = nil)
      current_node = self
      if current_node.parent.nil?
        digraph do
          rect << node(current_node.name)
          name = '[BEFORE] '+"#{current_node.number}\n"
          current_node.before_list.each { |before|
            name += ">#{before}"
          }
          rectangle << node(name)
          green << edge(current_node.name, name)

          current_node.node_list.each { |child_node|
            child_node.commands.each { |command|
              child_node.name += "\n >" +command.to_s
            }
            rect << node(child_node.name)
            edge(current_node.name, child_node.name)
            child_node.print_tree(self)
          }

          name = '[AFTER] '+"#{current_node.number}\n"
          current_node.after_list.each { |after|
            name += ">#{after}"
          }
          rect << node(name)
          red << edge(current_node.name, name)

          save "execution_graph", "png"
        end
      elsif !graph.nil? then
        graph.node(current_node.name)
        if current_node.before_list.length > 0 then
          name = '[BEFORE] '+"#{current_node.number}\n"
          current_node.before_list.each { |before|
            name += ">#{before}"
          }
          graph.rectangle << graph.node(name)
          graph.green << graph.edge(current_node.name, name)
        end
        current_node.node_list.each { |child_node|
          child_node.commands.each { |command|
            child_node.name += "\n >" +command.to_s
          }
          graph.rect << graph.node(child_node.name)
          graph.edge(current_node.name, child_node.name)
          child_node.print_tree(graph)
        }

        if current_node.after_list.length > 0 then
          name = '[AFTER] '+"#{current_node.number}\n"
          current_node.after_list.each { |after|
            name += ">#{after}"
          }
          graph.rect << graph.node(name)
          graph.red << graph.edge(current_node.name, name)
        end
      end
    end

end
