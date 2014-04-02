module Wrappable
  class WrapperOptions
    attr_reader :before, :after
    def initialize(&block)
      instance_eval(&block)
    end
    private
    def before_run(method_name)
      @before = method_name
    end
    def after_run(method_name)
      @after = method_name
    end
  end

  def wrap(original_method, &block)
    wrapper_options = WrapperOptions.new(&block)
    alias_method :old_method, original_method
    define_method original_method do
      send(wrapper_options.before)
      send(:old_method)
      send(wrapper_options.after)
    end
  end
end

class Wrapper

	attr_accessor :before, :after, :execute;	
	
	def perform
		if ! before.nil?
			before.call
		end
		if ! execute.nil?  
			execute.call
		end
		if ! after.nil? 
			after.call
		end
	end

end