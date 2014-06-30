class Item

	attr_reader :name, :hidden

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@hidden = options[:hidden] || false
	end

end

# can be eaten,
# use item.is_a? Food
class Food < Item
end