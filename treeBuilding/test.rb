require './foreach.rb'

instances = ["inscance1", "instance2", "instance3"]

foreach [1, 2, 3, 4], asynchronously, safely do |x|
	before do
		puts "before"
	end
	foreach instances do |instance|
		on instance, asynchronously do 
			foreach ['a', 'b', 'c'], asynchronously do |y|
				before do 
					puts "other before"
				end
				execute do
					print "[x: ", x, ", y: ", y, "]\n"
				end
			end
		end
	end
end
