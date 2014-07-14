class Player < ConquestClass

	attr_accessor :items, :current_room, :weapon
	attr_reader :xp, :health, :weapon

	def setup
		@items ||= {}
		@xp ||= 10
		@health ||= 45
		@weapon ||= ["none", 0]
		self
	end

	def xp=(new_xp)
		diff = new_xp - @xp
		@xp = new_xp
		puts "+#{diff}xp!" if diff > 0
	end

	def die
		puts "What a disapointment...".red
		exit
	end

	def is_alive
		@health > 0
	end

	def health=(new_health)
		@health = new_health
		die unless is_alive
	end

	def eat(food)
		if the_food = @items[food.to_sym]
			the_food.eat
			@items.delete(food.to_sym)
		else
			puts "You don't have that food."
		end
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
		@items.values.each do |item|
			a_or_an = %w[a e i o u].include?(item.name[0]) \
				? "an " : "a "
			a_or_an = "" if item.name[-1] == "s"
			if item.is_a?(Weapon)
				puts "#{a_or_an}#{item.name.downcase} with damage of #{item.damage}"
			else
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end
	end

	def fight(enemy)
		old_room_key = $rooms.key(@current_room)

		fight_scene = FightScene.new(name: "#{$player_name} vs #{enemy.name}", desc: "idk yet", enemy: enemy)
		@current_room = fight_scene.enter

		@current_room = $rooms[old_room_key]

	end

	def smack
		rand(2..4) + $player.weapon[1]
	end

	def info
		puts "Health: #@health"
		puts "XP: #@xp"
		puts "Inventory:"
		puts "Weapon: #{@weapon[0]}"
		puts "Inventory:"
		inventory
	end

	def walk(place)
		if place == "to mordor"
			puts "One does not simply walk to Mordor... You need to find the eagles.\nThey will take you to Mordor."
			false
		elsif place == "to merge conflictia"
			:merge_conflictia
		else
			@current_room[place.to_sym]
		end
	end

end
