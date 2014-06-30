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
		unless @visited
			puts @description
			list_items
		end
		@visited = true # can't hurt to set it every time, right?
		self
	end

	def remove_item(item)
		@items.delete(item.to_sym)
	end

	def look
		puts @name.cyan
		puts @description
		list_items
	end

	def list_items
		@items.values.map { |item|
			unless item.hidden
				a_or_an = %w[a e i o u].include?(item.name[0]) \
					? "an" : "a"
				puts "#{a_or_an} #{item.name.downcase}"
			end
		}
	end

end