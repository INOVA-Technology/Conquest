class Item

	attr_reader :name

	def initialize(name, description)
		@name = name
		@description = description
	end

end

# can be eaten,
# use item.is_a? Food
class Food < Item
end