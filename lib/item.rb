class Item

	attr_reader :name, :hidden, :can_pickup

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@options = options
		@hidden = options[:hidden] || false
		@can_pickup = options[:hidden] || true
		add_info
	end

	def add_info
	end

end


# SUBCLASSES BELOW: (only subclass when you have a good reason)

# can be eaten,
# use item.is_a? Food
class Food < Item
end

class Tree < Item
	def add_info
		@hidden = true
		@can_pickup = false
	end

	def climb
		if @options[:can_climb]
			puts @description
		else
			puts "You start climbing the tree, but you don't get far before you fall down."
		end
	end
end