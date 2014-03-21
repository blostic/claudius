class Array
  def my_map
    result = []
    self.each do |item|
      result << yield(item)
    end
    result
  end

  def cartesian_product
  	result = self.shift
    self.each do |item|
      result = result.product(item)
    end
  	return result
  end

end

# specifieng parameters

# parameters set cartesian_product of [[1, 2], [3, 4]] filterBy  

list =  [[1.1, 2.3], [3, 4]].cartesian_product
puts "fianal: #{list}"


