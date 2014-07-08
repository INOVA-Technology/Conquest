class Player

	attr_accessor :items, :current_room

	def initialize
		@items = {}
		@quests = QuestList.quests
		@achievements = AchievementList.achievements
	end

	def pickup(key, item)
		@items[key.to_sym] = item
		if key == "scroll"
			@quests[:mordor].start
		elsif key == "peach"
			@achievements[:peach].unlock
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