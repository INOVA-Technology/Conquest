class Player

	attr_accessor :items, :current_room, :xp

	def initialize
		@items = {}
		@xp = 10
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
		old_room_key = $rooms.key(@current_room)

		fight_scene = FightScene.new("(get player name at begining of game and put it here) vs #{enemy.name}", "idk", {enemy: enemy})
		@current_room = fight_scene.enter

		@current_room = $rooms[old_room_key]

	end

	def smack
		rand(2..4)
	end

end
