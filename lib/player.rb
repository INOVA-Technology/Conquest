require "yaml"

class Player

	attr_accessor :items

	def initialize
		@items = {}	
	end

	def pickup(key, item)
		@items[key.to_sym] = item
		if key == "scroll"

			@quests = YAML.load_file("./yaml/quests.yml")
			@quests[:mordor] = true
			puts "#{'Quest started!'.cyan} - Onward to Mordor"
			

		end
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