class Room

	attr_reader :items, :options, :people

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@paths = options[:paths] || {}
		@items = options[:items] || {}
		@people = options[:people] || {}
		@options = options
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
		visible_items = @items.values.select { |i| (!i.hidden) && i.can_pickup }
		unless visible_items.empty?

			puts "Items that are here:".magenta
			visible_items.map do |item|
				a_or_an = %w[a e i o u].include?(item.name[0]) \
					? "an " : "a "
				a_or_an = "" if item.name[-1] == "s"
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end

		visible_people = @people.values.select { |i| (!i.hidden)}
		unless visible_people.empty?

			puts "People that are here:".magenta
			visible_people.map do |people|
				#puts people.bad_guy
				if people.bad_guy == true
					puts "#{people.name.red}"
				else
					puts "#{people.name}"
				end
			end
		end

	end

end
