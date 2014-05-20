require './treeBuilding/node.rb'

class OnNode < Node
	attr_accessor :instance
	def initialize (parent, instance, block)
		super(parent, block)
		self.instance = instance
    self.name = 'OnNode: ' + instance
  end

  def run(indent, instance)
    before_list.each do |before|
      if instance.nil? then
        `#{before}`
      end
    end

    node_list.each do |node|
      node.run(indent + 2, @instance)
    end

    after_list.each do |after|
      print ' ' * indent
      if instance.nil? then
        `#{after}`
      end
    end
  end

end