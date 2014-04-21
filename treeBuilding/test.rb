require './foreach.rb'

foreach [1, 2, 3, 4], asynchronously, safely do |x|
	before do
		puts "before"
	end
	foreach ['a', 'b', 'c'], asynchronously do |y|
		before do 
			puts "other before"
		end
		print "[x: ", x, ", y: ", y, "]\n"
	end
end

