class Item

	attr_reader :name, :hidden

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@hidden = options[:hidden] || false
	end

end


# SUBCLASSES BELOW: (only subclass when you have a good reason)

# can be eaten,
# use item.is_a? Food
class Food < Item
end