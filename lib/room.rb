class Room

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@paths = options[:paths] || {}
		@items = options[:items] || {}

		@visited = false
	end

	def [](direction)
		@paths[direction.to_sym]
	end

	def enter
		puts @name.cyan
		puts @description unless @visited
		@visited = true
		self
	end

	def remove_item(item)
		@items.delete(item.to_sym)
	end

end