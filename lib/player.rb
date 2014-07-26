class Player

	attr_accessor :items, :current_room, :weapon, :time, :start_time, :name
	attr_reader :xp, :health, :weapon

	def initialize
		@items = {}
		@xp = 10
		@xp_max = 100
		@rank = 0
		@health = 45
		@max_health = 45
		@weapon = nil
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

	def xp=(new_xp)
		diff = new_xp - @xp
		@xp = new_xp
		puts "+#{diff}xp!" if diff > 0
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
		puts "What would you like to upgrade?".cyan
		puts "Attack (+#{_attack}) | Health (+#{_health}) | Cancel".yellow
		input = prompt

		case input
		when "cancel", "c"
			puts "Your loss!"
			return
		when "health", "h"
			health += _health # using health += because @health += doesn't call the custom health= method
		when "attack", "a"
			@weapon.upgrade + _attack
		else
			puts "Come again?"
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

	def health=(new_health)
		old_health = @health
		@health = new_health
		if @health > @max_health
			@health = @max_health
		end
		diff = @health - old_health
		puts "+#{diff}health!" if diff > 0
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
					xp += (item.item_xp) # using xp += because @xp += doesn't call the custom xp= method
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
