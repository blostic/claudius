class Wrapper
	attr_accessor :before, :after, :execute, :before_each, :after_each;	
	
  def initialize

      @execute = Array.new
      @before_each = Proc.new{}
      @after = Proc.new{}
      @before = Proc.new{}
      @before_each = Proc.new{}
      @after_each = Proc.new{}
  end

	def perform		
			before.call
      for task in execute do 
        before_each.call
        task.call
        after_each.call
      end
			after.call
	end

end
