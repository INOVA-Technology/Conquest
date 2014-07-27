class Player

	attr_accessor :items, :current_room, :weapon, :time, :start_time, :name
	attr_reader :xp, :health, :weapon

	def initialize
		@items = {}
		@xp = 10
		@xp_max = 100
		@rank = 0
		@health = 45
		@weapon = nil
		@upgrades = 0
		# its year, month, day, hour, minute
		# the year, month, and day should be changed. Probably to the past
		@start_time = [2000, 1, 1, 6, 30]
		@time = { virtual: DateTime.new(*@start_time) }
		@time[:real] = DateTime.now
		self
	end

	def get_time
		@time[:virtual] + time_since_start
	end

	def time_since_start
		DateTime.now - @time[:real]
	end

	def give_xp(amount)
		@xp += amount
		puts "+#{amount}xp!"
		$achievements[:over_9000].unlock if @xp > 9000
		rank_up
	end

	def rank_up
		if @xp >= @xp_max
			@rank += 1
			puts "Rank up!".magenta
			puts "Level #{@rank}"
			@xp -= @xp_max 
			@xp_max = @xp_max*2
			@upgrades += 1
			puts "New upgrade available!".magenta
			upgrade
			rank_up
		end
	end

	def upgrade
		(_health, _attack) = [3, 1]
		puts "What would you like to upgrade? #{@upgrades} upgrades available".cyan
		puts "Attack (+#{_attack}) | Health (+#{_health}) | Cancel".yellow
		input = prompt

		case input
		when "cancel", "c"
			puts ["Your loss!", "What a loser...", "Thx for waisting my time.", "Sure! Great idea! Let's waiste the narrators time and pretend we r gonna upgrade something and don't!"].sample
			return
		when "health", "h"
			heal(_health)
			_health += 3
			puts "Health #{"+".cyan + _health.to_s.cyan}"
		when "attack", "a"
			if @weapon != nil
				@weapon.upgrade + _attack
				puts "Weapon upgraded! #{"+".cyan + _attack.to_s.cyan}"
				puts "Weapon Level: #{@weapon.upgrade.to_s.yellow}"
			else
				puts "No weapon equipped"
				upgrade
			end
		else
			puts ["Do I need to put it in braille for u?", "I'm sorry I don't speak idiot.", "hmmm... can u put that in words plz?", "hmmm... I see..", "U really need mental help"].sample
			upgrade
		end
	end

	def die(message = "What a disapointment...")
		puts message.red
		File.delete("#{Dir.home}/.conquest_save")
		exit
	end

	def is_alive
		@health > 0
	end

	def heal(amount)
		@health += amount
		puts "+#{amount}health!"
	end

	def take_damage(amount)
		@health -= amount
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

	def pickup(key)
		if item = item_in_room(key)
			if item.can_pickup
				@current_room.pickup_item(key)
				@items[key.to_sym] = item
				if item.item_xp != 0 # 👻
					give_xp(item.item_xp)
					puts "xp +#{item.item_xp}".cyan
				end
			else
				puts "You can't pick that up."
			end
		else
			puts "That item isn't here."
		end
	end

	def inventory
		@items.values.each do |item|
			a_or_an = %w[a e i o u].include?(item.name[0]) \
				? "an " : "a "
			a_or_an = "" if item.name[-1] == "s"
			if item.is_a?(Weapon)
				puts "#{a_or_an}#{item.name.downcase}"
				puts "  " + (@weapon == item ? "Equiped" : "Not equiped")
				puts "  Upgrades: #{item.upgrade}"
			else
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end
	end

	def smack
		rand(2..4)
	end

	def info
		puts "Health: #@health"
		puts "Rank: #{@rank}"
		puts "XP: #{@xp}/#{@xp_max} "
		if @weapon != nil
			puts "Current Weapon: #{@weapon.name}"
		end
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

	def item_in_room(item)
		@current_room.items[item.to_sym]
	end

end
