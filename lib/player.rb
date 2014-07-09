class Player

	attr_accessor :items, :current_room

	def initialize
		@items = {}
	end

	def pickup(key, item)
		@items[key.to_sym] = item
		case key
		when "scroll"
			$quests[:mordor].start
			$achievements[:mordor].unlock
		when "peach"
			$achievements[:peach].unlock
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

	def fight(enemy)
		# old_room = @current_room.idk
		fight_scene = FightScene.new("")
		@current_room = fight_scene

		# @current_room = old_room

	end

end