class Player

	def initialize
		@items = {}	
	end

	def pickup(item)
		@items[item.name.to_sym] = item
	end

	def inventory
		@items.values.each { |item|
			a_or_an = %w[a e i o u].include?(item.name[0]) \
				? "an " : "a " 
			a_or_an = "" if item.name[-1] == "s"
			puts "#{a_or_an}#{item.name.downcase}"
		}
	end

end